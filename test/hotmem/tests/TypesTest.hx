package hotmem.tests;

import utest.Assert;

class TypesTest {

	public function new() {}

	public function testU8() {
		var i:U8 = 3;
		Assert.equals(3, i);

		var i2:U8 = 255;
		Assert.equals(255, i2);

		var i3:U8 = 0;
		Assert.equals(0, i3);
	}

	public function testU16() {
		var i:U16 = 0;
		Assert.equals(0, i);

		var i2:U16 = 0xFFFF;
		Assert.equals(0xFFFF, i2);
	}

	public function testI32() {
		var i:I32 = 0;
		Assert.equals(0, i);

		var i2:I32 = 0xFFFFFFFF;
		Assert.equals(0xFFFFFFFF, i2);
	}

	public function testF32() {
		var f:F32 = 0;
		Assert.floatEquals(0, f);

		f = -0.0002;
		Assert.floatEquals(-0.0002, f);
	}
}
