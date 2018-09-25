package hotmem.tests;

import utest.Assert;

class ArraysTest {

	public function new() {}

	public function testU8() {
		var array = new U8Array(256);
		Assert.isFalse(array == U8Array.NULL);
		Assert.equals(256, array.length);
		for(i in 0...array.length) {
			array[i] = i;
		}

		Assert.equals(0, array[0]);
		Assert.equals(127, array[127]);
		Assert.equals(255, array[255]);

		// TODO: cast
//		var dwords:I32Array = cast array;
//		Assert.equals(dwords.length, array.length >> 2);
//		dwords[1] = 0;
//		Assert.equals(0, array[4]);
//		Assert.equals(0, array[5]);
//		Assert.equals(0, array[6]);
//		Assert.equals(0, array[7]);

//		array.dispose();
//		Assert.isTrue(array == U8Array.NULL);
	}
}
