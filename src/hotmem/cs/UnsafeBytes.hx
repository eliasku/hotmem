package hotmem.cs;

#if cs

import cs.types.UInt16;
import cs.types.UInt8;
import cs.NativeArray;

@:unsafe @:final @:unreflective @:nativeGen @:keep
@:classCode("
	public static void setU8(byte[] bytes, int address, byte value) {
		fixed (byte* ptr = bytes) { ptr[address] = value; }
	}

	public static void setU16(byte[] bytes, int address, int value) {
		fixed (byte* ptr = bytes) { *((ushort*)(ptr + address)) = (ushort)value; }
	}

	public static void setI32(byte[] bytes, int address, int value) {
		fixed (byte* ptr = bytes) { *((int*)(ptr + address)) = value; }
	}

	public static void setF32(byte[] bytes, int address, float value) {
		fixed (byte* ptr = bytes) { *((float*)(ptr + address)) = value; }
	}

	public static byte getU8(byte[] bytes, int address) {
		fixed (byte* ptr = bytes) { return ptr[address]; }
	}

	public static ushort getU16(byte[] bytes, int address) {
		fixed (byte* ptr = bytes) { return *((ushort*)(ptr + address)); }
	}

	public static int getI32(byte[] bytes, int address) {
		fixed (byte* ptr = bytes) { return *((int*)(ptr + address)); }
	}

	public static float getF32(byte[] bytes, int address) {
		fixed (byte* ptr = bytes) { return *((float*)(ptr + address)); }
	}
	
	public static void psetU8(global::System.IntPtr iptr, int address, byte value) {
		byte* ptr = (byte*)iptr.ToPointer();
		ptr[address] = value;
	}

	public static void psetU16(global::System.IntPtr iptr, int address, int value) {
		byte* ptr = (byte*)iptr.ToPointer();
		*((ushort*)(ptr + address)) = (ushort)value;
	}

	public static void psetI32(global::System.IntPtr iptr, int address, int value) {
		byte* ptr = (byte*)iptr.ToPointer();
		*((int*)(ptr + address)) = value;
	}

	public static void psetF32(global::System.IntPtr iptr, int address, float value) {
		byte* ptr = (byte*)iptr.ToPointer();
		*((float*)(ptr + address)) = value;
	}

	public static byte pgetU8(global::System.IntPtr iptr, int address) {
		byte* ptr = (byte*)iptr.ToPointer();
		return *(ptr + address);
	}

	public static ushort pgetU16(global::System.IntPtr iptr, int address) {
		byte* ptr = (byte*)iptr.ToPointer();
		return *((ushort*)(ptr + address));
	}

	public static int pgetI32(global::System.IntPtr iptr, int address) {
		byte* ptr = (byte*)iptr.ToPointer();
		return *((int*)(ptr + address));
	}

	public static float pgetF32(global::System.IntPtr iptr, int address) {
		byte* ptr = (byte*)iptr.ToPointer();
		return *((float*)(ptr + address));
	}

	public static global::System.IntPtr getPtr(int[] bytes) {
		fixed(void* ptr = bytes) {
			return new global::System.IntPtr(ptr);
		}
	}

	public static global::System.IntPtr getPtr(float[] bytes) {
		fixed(void* ptr = bytes) {
			return new global::System.IntPtr(ptr);
		}
	}

	public static global::System.IntPtr getPtr(ushort[] bytes) {
		fixed(void* ptr = bytes) {
			return new global::System.IntPtr(ptr);
		}
	}

	public static global::System.IntPtr getPtr(byte[] bytes) {
		fixed(void* ptr = bytes) {
			return new global::System.IntPtr(ptr);
		}
	}
")
class UnsafeBytes {
	@:overload(function(bytes:NativeArray<UInt8>):cs.system.IntPtr {})
	@:overload(function(bytes:NativeArray<UInt16>):cs.system.IntPtr {})
	@:overload(function(bytes:NativeArray<Single>):cs.system.IntPtr {})
	@:extern public static function getPtr(bytes:NativeArray<Int>):cs.system.IntPtr {return null;}

	@:extern public static function setU8(bytes:NativeArray<UInt8>, address:Int, value:UInt8):Void {}
	@:extern public static function setU16(bytes:NativeArray<UInt8>, address:Int, value:Int):Void {}
	@:extern public static function setI32(bytes:NativeArray<UInt8>, address:Int, value:Int):Void {}
	@:extern public static function setF32(bytes:NativeArray<UInt8>, address:Int, value:Single):Void {}

	@:extern public static function getU8(bytes:NativeArray<UInt8>, address:Int):UInt8 {return 0;}
	@:extern public static function getU16(bytes:NativeArray<UInt8>, address:Int):Int return 0;
	@:extern public static function getI32(bytes:NativeArray<UInt8>, address:Int):Int return 0;
	@:extern public static function getF32(bytes:NativeArray<UInt8>, address:Int):Single return 0;

	@:extern public static function psetU8(ptr:cs.system.IntPtr, address:Int, value:UInt8):Void {}
	@:extern public static function psetU16(ptr:cs.system.IntPtr, address:Int, value:Int):Void {}
	@:extern public static function psetI32(ptr:cs.system.IntPtr, address:Int, value:Int):Void {}
	@:extern public static function psetF32(ptr:cs.system.IntPtr, address:Int, value:Single):Void {}

	@:extern public static function pgetU8(ptr:cs.system.IntPtr, address:Int):UInt8 {return 0;}
	@:extern public static function pgetU16(ptr:cs.system.IntPtr, address:Int):Int return 0;
	@:extern public static function pgetI32(ptr:cs.system.IntPtr, address:Int):Int return 0;
	@:extern public static function pgetF32(ptr:cs.system.IntPtr, address:Int):Single return 0;
}

#end
