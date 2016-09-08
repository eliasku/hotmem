package hotmem.tests;

import haxe.io.Bytes;
import utest.Assert;

class HotBytesTest {

	public function new() {}

#if (js||flash||macro||neko||cpp||java||cs)
	public function testBytesView() {
		var bytes = Bytes.alloc(100);
		var view = HotMemory.lock(bytes.getData());
		for(i in 0...bytes.length) {
			view.set(i, i);
		}
		view.setF32(4, 0.5);
		view.setU32(8, 0xDEADBABE);
		view.setU16(12, 0x7777);

		Assert.floatEquals(0.5, view.getF32(4));
		Assert.equals(0xDEADBABE, view.getU32(8));
		Assert.equals(0x7777, view.getU16(12));
		Assert.equals(0, view.get(0));
		Assert.equals(1, view.get(1));
		Assert.equals(2, view.get(2));
		Assert.equals(3, view.get(3));
		Assert.equals(77, view.get(77));

		HotMemory.unlock();
	}
#else
	public function testPass() {
		Assert.pass();
	}
#end
}
