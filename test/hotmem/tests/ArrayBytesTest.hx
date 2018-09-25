package hotmem.tests;

import utest.Assert;

class ArrayBytesTest {

	public function new() {}

#if (neko||hl)
	public function testPass() {
		Assert.pass();
	}
#else
	public function testArrayBytes() {
		var data = new I32Array(20);
		var bytes = data.getArrayBytes();
		for(i in 0...(data.length * 4)) {
			bytes.setU8(i, i);
		}
		bytes.setF32(4, 0.5);
		bytes.setI32(8, 0xDEADBABE);
		bytes.setU16(12, 0x7777);

		Assert.floatEquals(0.5, bytes.getF32(4));
		Assert.equals(0xDEADBABE, bytes.getI32(8));
		Assert.equals(0x7777, bytes.getU16(12));
		Assert.equals(0, bytes.getU8(0));
		Assert.equals(1, bytes.getU8(1));
		Assert.equals(2, bytes.getU8(2));
		Assert.equals(3, bytes.getU8(3));
		Assert.equals(77, bytes.getU8(77));
	}
#end

}