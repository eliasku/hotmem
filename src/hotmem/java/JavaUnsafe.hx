package hotmem.java;

#if java

import java.types.Int16;
import java.types.Int8;
import java.NativeArray;
import java.lang.reflect.Field;
import java.lang.Long;

@:keep
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

#end