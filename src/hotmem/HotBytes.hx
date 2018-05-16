package hotmem;

#if java
import hotmem.java.JavaUnsafe;
#elseif cs
import hotmem.cs.UnsafeBytes;
#end

#if js
private typedef HotBytesData = hotmem.js.HotBytesImpl;
#elseif flash
private typedef HotBytesData = Int;
#else
private typedef HotBytesData = haxe.io.BytesData;
#end

#if cs
@:unsafe
#end
abstract HotBytes(HotBytesData) {

#if flash
	public inline static var NULL:HotBytes = new HotBytes(0);
#else
	public inline static var NULL:HotBytes = null;
#end

	inline public function new(data:HotBytesData) {
		this = data;
	}

	@:arrayAccess
	public inline function set(address:Int, value:U8) {
		setU8(address, value);
	}
	
	@:arrayAccess
	public inline function get(address:Int):U8 {
		return getU8(address);
	}

	public inline function setF32(address:Int, value:F32) {
#if cpp
		untyped __global__.__hxcpp_memory_set_float(this, address, value);
#elseif js
		this.setF32(address, value);
#elseif flash
		flash.Memory.setFloat(address, value);
#elseif neko
		untyped __dollar__ssetf(this, address, value, false);
#elseif java
		untyped __java__("hotmem.java.JavaUnsafe.UNSAFE.putFloat({0}, hotmem.java.JavaUnsafe.BYTE_ARRAY_BASE_OFFSET + {1}, (float){2})", this, address, value);
#elseif cs
		UnsafeBytes.setF32(this, address, value);
#end
	}

	public inline function setU32(address:Int, value:Int) {
#if cpp
		untyped __global__.__hxcpp_memory_set_ui32(this, address, value);
#elseif js
		this.setU32(address, value);
#elseif flash
		flash.Memory.setI32(address, value);
#elseif neko
		untyped __dollar__sset32(this, address, value, false);
#elseif java
		untyped __java__("hotmem.java.JavaUnsafe.UNSAFE.putInt({0}, hotmem.java.JavaUnsafe.BYTE_ARRAY_BASE_OFFSET + {1}, {2})", this, address, value);
#elseif cs
		UnsafeBytes.setI32(this, address, value);
#end
	}

	public inline function setU16(address:Int, value:U16) {
#if cpp
		untyped __global__.__hxcpp_memory_set_ui16(this, address, value);
#elseif js
		this.setU16(address, value);
#elseif flash
		flash.Memory.setI16(address, value);
#elseif neko
		untyped __dollar__sset16(this, address, value, false);
#elseif java
		untyped __java__("hotmem.java.JavaUnsafe.UNSAFE.putShort({0}, hotmem.java.JavaUnsafe.BYTE_ARRAY_BASE_OFFSET + {1}, (short){2})", this, address, value);
#elseif cs
		UnsafeBytes.setU16(this, address, value);
#end
	}


	public inline function setU8(address:Int, value:U8) {
#if cpp
		untyped this[address] = value;
#elseif js
		this.setU8(address, value);
#elseif flash
		flash.Memory.setByte(address, value);
#elseif neko
		untyped __dollar__sset(this, address, value);
#elseif java
		untyped __java__("hotmem.java.JavaUnsafe.UNSAFE.putByte({0}, hotmem.java.JavaUnsafe.BYTE_ARRAY_BASE_OFFSET + {1}, (byte){2})", this, address, value);
#elseif cs
		UnsafeBytes.setU8(this, address, value);
#end
	}

	public inline function getF32(address:Int):F32 {
#if cpp
		return untyped __global__.__hxcpp_memory_get_float(this, address);
#elseif js
		return this.getF32(address);
#elseif flash
		return flash.Memory.getFloat(address);
#elseif neko
		return untyped __dollar__sgetf(this, address, false);
#elseif java
		return untyped __java__("hotmem.java.JavaUnsafe.UNSAFE.getFloat({0}, hotmem.java.JavaUnsafe.BYTE_ARRAY_BASE_OFFSET + {1})", this, address);
#elseif cs
		return UnsafeBytes.getF32(this, address);
#else
		return 0;
#end
	}

	public inline function getU32(address:Int):Int {
#if cpp
		return untyped __global__.__hxcpp_memory_get_ui32(this, address);
#elseif js
		return this.getU32(address);
#elseif flash
		return flash.Memory.getI32(address);
#elseif neko
		return untyped __dollar__sget32(this, address, false);
#elseif java
		return untyped __java__("hotmem.java.JavaUnsafe.UNSAFE.getInt({0}, hotmem.java.JavaUnsafe.BYTE_ARRAY_BASE_OFFSET + {1}) & 0xFFFFFFFF", this, address);
#elseif cs
		return UnsafeBytes.getI32(this, address);
#else
		return 0;
#end
	}

	public inline function getU16(address:Int):U16 {
#if cpp
		return untyped __global__.__hxcpp_memory_get_ui16(this, address);
#elseif js
		return this.getU16(address);
#elseif flash
		return flash.Memory.getUI16(address);
#elseif neko
		return untyped __dollar__sget16(this, address, false);
#elseif java
		return untyped __java__("hotmem.java.JavaUnsafe.UNSAFE.getShort({0}, hotmem.java.JavaUnsafe.BYTE_ARRAY_BASE_OFFSET + {1}) & 0xFFFF", this, address);
#elseif cs
		return UnsafeBytes.getU16(this, address);
#else
		return 0;
#end
	}

#if cs
	@:unsafe
#end
	public inline function getU8(address:Int):U8 {
#if cpp
		return untyped this[address];
#elseif js
		return this.getU8(address);
#elseif flash
		return flash.Memory.getByte(address);
#elseif neko
		return untyped __dollar__sget(this, address);
#elseif java
		return untyped __java__("hotmem.java.JavaUnsafe.UNSAFE.getByte({0}, hotmem.java.JavaUnsafe.BYTE_ARRAY_BASE_OFFSET + {1})", this, address);
#elseif cs
		return UnsafeBytes.getU8(this, address);
#else
		return 0;
#end
	}
}
