import hxmake.cli.CL;
import hxmake.Task;
import hxmake.test.TestTask;
import hxmake.haxelib.HaxelibExt;
import hxmake.idea.IdeaPlugin;
import hxmake.haxelib.HaxelibPlugin;

using hxmake.haxelib.HaxelibPlugin;

class HotMemMake extends hxmake.Module {

	function new() {
		config.classPath = ["src"];
		config.testPath = ["test", "hotmem"];
		config.devDependencies = [
			"utest" => "haxelib"
		];

		apply(HaxelibPlugin);
		apply(IdeaPlugin);

		library(function(ext:HaxelibExt) {
			ext.config.version = "0.0.2";
			ext.config.description = "Hot-memory library for Haxe";
			ext.config.url = "https://github.com/eliasku/hotmem";
			ext.config.tags = ["memory", "hot", "data", "access", "primitive", "cross"];
			ext.config.contributors = ["eliasku"];
			ext.config.license = "MIT";
			ext.config.releasenote = "Initial release";

			ext.pack.includes = ["src", "haxelib.json", "README.md"];
		});

		var tt = new TestTask();
		tt.debug = true;
		tt.targets = ["neko", "swf", "node", "js", "cpp", "java", "cs"];
		tt.libraries = ["ecx"];
		task("test", tt);

		task("generate", new GenerateHotMem());
	}
}
