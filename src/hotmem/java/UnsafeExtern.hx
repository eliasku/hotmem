package hotmem.java;

#if java

import java.types.Int16;
import java.lang.Long;
import java.types.Int8;
import java.NativeArray;

extern class UnsafeExtern {
	@:extern public function getByte(obj:NativeArray<Int8>, address:Long):Int;
	@:extern public function putByte(obj:NativeArray<Int8>, address:Long, value:Int8):Void;
	@:extern public function getFloat(obj:NativeArray<Int8>, address:Long):Single;
	@:extern public function putFloat(obj:NativeArray<Int8>, address:Long, value:Single):Void;
	@:extern public function getShort(obj:NativeArray<Int8>, address:Long):Int16;
	@:extern public function putShort(obj:NativeArray<Int8>, address:Long, value:Int16):Void;
	@:extern public function getInt(obj:NativeArray<Int8>, address:Long):Int;
	@:extern public function putInt(obj:NativeArray<Int8>, address:Long, value:Int):Void;
}

#end