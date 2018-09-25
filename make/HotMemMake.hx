package ;

import hxmake.test.TestTask;
import hxmake.haxelib.HaxelibExt;
import hxmake.haxelib.HaxelibPlugin;
import hxmake.idea.IdeaPlugin;

using hxmake.haxelib.HaxelibPlugin;

class HotMemMake extends hxmake.Module {

	function new() {
		config.classPath = ["src"];
		config.testPath = ["test", "templates"];
		config.devDependencies = [
			"utest" => "haxelib"
		];

		apply(HaxelibPlugin);
		apply(IdeaPlugin);

		this.library(function(ext:HaxelibExt) {
			ext.config.version = "0.0.4";
			ext.config.description = "Hot memory access library for Haxe";
			ext.config.url = "https://github.com/eliasku/hotmem";
			ext.config.tags = ["memory", "hot", "data", "array", "access", "primitive", "cross", "cache"];
			ext.config.contributors = ["eliasku"];
			ext.config.license = "MIT";
			ext.config.releasenote = "update";

			ext.pack.includes = ["src", "haxelib.json", "README.md", "LICENSE"];
		});

		task("generate", new GenerateHotMem());

		var testTask = new TestTask();
		testTask.debug = true;
		// TODO: "neko"
		testTask.targets = ["neko", "swf", "node", "js", "cpp", "java", "cs"];
		testTask.libraries = ["hotmem"];
		task("test", testTask);
	}
}
