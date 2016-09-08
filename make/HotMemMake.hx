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

		library(function(ext:HaxelibExt) {
			ext.config.version = "0.0.3";
			ext.config.description = "Hot memory access library for Haxe";
			ext.config.url = "https://github.com/eliasku/hotmem";
			ext.config.tags = ["memory", "hot", "data", "array", "access", "primitive", "cross", "cache"];
			ext.config.contributors = ["eliasku"];
			ext.config.license = "MIT";
			ext.config.releasenote = "check bounds";

			ext.pack.includes = ["src", "haxelib.json", "README.md", "LICENSE"];
		});

		task("generate", new GenerateHotMem());

		var tt = new TestTask();
		tt.debug = true;
		// TODO: "neko"
		tt.targets = ["swf", "node", "js", "cpp", "java", "cs"];
		tt.libraries = ["hotmem"];
		task("test", tt);
	}
}
