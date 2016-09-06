package hotmem.java;

#if java

import java.types.Int16;
import java.types.Int8;
import java.NativeArray;
import java.lang.reflect.Field;
import java.lang.Long;

@:classCode('
 public static sun.misc.Unsafe UNSAFE;

  public static long BYTE_ARRAY_BASE_OFFSET;

  static {
    try {
      java.lang.reflect.Field unsafeField = sun.misc.Unsafe.class.getDeclaredField("theUnsafe");
      unsafeField.setAccessible(true);
      UNSAFE = (sun.misc.Unsafe) unsafeField.get(null);
      BYTE_ARRAY_BASE_OFFSET = UNSAFE.arrayBaseOffset(byte[].class);
    } catch (NoSuchFieldException e) {
      UNSAFE = null;
    } catch (IllegalAccessException e) {
      UNSAFE = null;
    }
  }
')
class JavaUnsafe {
	@:extern public static var UNSAFE:UnsafeExtern;
	@:extern public static var BYTE_ARRAY_BASE_OFFSET:Int;
}

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