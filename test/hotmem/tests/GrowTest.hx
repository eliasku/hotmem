package hotmem.tests;
import utest.Assert;
class GrowTest {
	public function new() {
	}

	public function testGrow() {
		var array = new U8Array(256);
		Assert.isFalse(array == U8Array.NULL);
		Assert.equals(256, array.length);
		for(i in 0...array.length) {
			array[i] = i;
		}

		var tempSize = 50 * 1000 * 1000;
		var tempArray = new U8Array(tempSize);
		tempArray[tempSize - 1] = 0x66;

		Assert.equals(tempSize, tempArray.length);
		Assert.equals(256, array.length);

		Assert.equals(0, array[0]);
		Assert.equals(127, array[127]);
		Assert.equals(255, array[255]);

		array.dispose();
		Assert.isTrue(array == U8Array.NULL);
	}
}
