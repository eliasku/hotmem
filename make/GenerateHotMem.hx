package ;

import haxe.Template;
import hxmake.Task;
import hxmake.cli.CL;
import sys.FileSystem;
import sys.io.File;

class GenerateHotMem extends Task {

	var _outputPath:String = "src/hotmem/";

	public function new() {}

	override public function run() {
		CL.workingDir.push(module.path);
		generate();
		CL.workingDir.pop();
	}

	function generate() {

		if(!FileSystem.exists(_outputPath)) {
			FileSystem.createDirectory(_outputPath);
		}

		var tplBuffer = new Template(File.getContent("templates/hotmem/Array.mtt.hx"));
		var tplType = new Template(File.getContent("templates/hotmem/Type.mtt.hx"));
		var tplHotMemory = new Template(File.getContent("templates/hotmem/HotMemory.mtt.hx"));
		var tplHotView = new Template(File.getContent("templates/hotmem/HotView.mtt.hx"));

		var types = [
			"U8",
			"U16",
			"I32",
			"F32"
		];
		var specificTypes = [
			"UInt8",
			"UInt16",
			"Int32",
			"Float32"
		];
		var csTypes = [
			"cs.StdTypes.UInt8",
			"Int",
			"Int",
			"Single"
		];
		var javaTypes = [
			"Int",//"java.StdTypes.Int8",
			"Int",//"java.StdTypes.Int16",
			"Int",
			"Single"
		];

		var javaLangTypes = [
			"byte",
			"short",
			"int",
			"float"
		];

		var genericTypes = [
			"Int",
			"Int",
			"Int",
			"Float"
		];
		var sizes = [
			1,
			2,
			4,
			4
		];
		var flash_get = ["getByte", "getUI16", "getI32", "getFloat"];
		var flash_set = ["setByte", "setI16", "setI32", "setFloat"];
		var amsjs_reg_prefix = ["", "", "", "+"];
		var amsjs_reg_postfix = ["|0", "|0", "|0", ""];
		var java_get = ["getByte", "getShort", "getInt", "getFloat"];
		var java_set = ["putByte", "putShort", "putInt", "putFloat"];
		var java_get_post_conv = ["& 0xFF", "& 0xFFFF", "", ""];

		var neko_get = ["__dollar__sget", "__dollar__sget16", "__dollar__sget32", "__dollar__sgetf"];
		var neko_set = ["__dollar__sset", "__dollar__sset16", "__dollar__sset32", "__dollar__ssetf"];
		var neko_le_postfix = ["", ", false", ", false", ", false"];

		var typesContext = { TYPES: [] };
		for(i in 0...types.length) {
			var typeName = types[i];
			var size = sizes[i];
			var context = {
				EL_SHIFT: size >> 1, // fix with log2
				EXPR_LEFT_SHIFT: "",
				EXPR_RIGHT_SHIFT: "",
				SIZE: size,
				FLASH_MEM_SET: flash_set[i],
				FLASH_MEM_GET: flash_get[i],

				JAVA_UNSAFE_GET_BIT_AND: java_get_post_conv[i],
				JAVA_UNSAFE_GET: java_get[i],
				JAVA_UNSAFE_SET: java_set[i],
				JAVA_TYPE: javaTypes[i],
				JAVA_LANG_TYPE: javaLangTypes[i],

				NEKO_LE_POSTFIX: neko_le_postfix[i],
				NEKO_GET: neko_get[i],
				NEKO_SET: neko_set[i],

				POST_ASMJS: amsjs_reg_postfix[i],
				PRE_ASMJS: amsjs_reg_prefix[i],
				TYPE: typeName,
				GENERIC_TYPE: genericTypes[i],
				SPECIFIC_TYPE: specificTypes[i],
				CS_TYPE: csTypes[i],
				CPP_POINTER_TYPE: 'cpp::${specificTypes[i]}*'
			};
			if(context.EL_SHIFT > 0) {
				context.EXPR_LEFT_SHIFT = " << " + context.EL_SHIFT;
				context.EXPR_RIGHT_SHIFT = " >> " + context.EL_SHIFT;
			}
			typesContext.TYPES.push(context);
			File.saveContent(_outputPath + typeName + "Array.hx", tplBuffer.execute(context));
			File.saveContent(_outputPath + typeName + ".hx", tplType.execute(context));
		}

		File.saveContent(_outputPath + "HotMemory.hx", tplHotMemory.execute(typesContext));
		File.saveContent(_outputPath + "HotView.hx", tplHotView.execute(typesContext));
	}
}
