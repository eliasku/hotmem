package hotmem;

#if (cpp||js||flash||java)

#if cpp
private typedef HotViewData = cpp.RawPointer<cpp.Char>;
#elseif (js||flash)
private typedef HotViewData = Int;
#elseif java
private typedef HotViewData = Dynamic;
#end

@:notNull
@:structAccess
@:unreflective
abstract HotView(HotViewData) from HotViewData to HotViewData {

#if cpp
	@:unreflective
	@:generic inline function new<T>(buffer:haxe.io.BytesData) {
		this = untyped __cpp__("{0}->GetBase()", buffer);
	}
#elseif java
	inline function new<T>(buffer:java.NativeArray<T>) {
		this = buffer;
	}
#elseif (flash||js)
	inline function new(address:Int) {
		this = address;
	}
#end


	@:unreflective
	public inline function setU8(address:Int, value:U8):Void {
#if (flash || js)
		hotmem.HotMemory.setU8(this + address, value);
#elseif cpp
		untyped __cpp__("*((cpp::UInt8*)({0} + {1})) = {2}", this, address, value);
#elseif java
		untyped __java__("hotmem.java.JavaUnsafe.UNSAFE.putByte({0}, hotmem.java.JavaUnsafe.BYTE_ARRAY_BASE_OFFSET + {1}, (byte){2})", this, address, value);
#end
	}

	@:unreflective
	public inline function getU8(address:Int):U8 {
#if (flash || js)
		return hotmem.HotMemory.getU8(this + address);
#elseif cpp
		return untyped __cpp__("*((cpp::UInt8*)({0} + {1}))", this, address);
#elseif java
		return untyped __java__("hotmem.java.JavaUnsafe.UNSAFE.getByte({0}, hotmem.java.JavaUnsafe.BYTE_ARRAY_BASE_OFFSET + {1})& 0xFF", this, address);
#else
		return 0;
#end
	}

	@:unreflective
	public inline function setU16(address:Int, value:U16):Void {
#if (flash || js)
		hotmem.HotMemory.setU16(this + address, value);
#elseif cpp
		untyped __cpp__("*((cpp::UInt16*)({0} + {1})) = {2}", this, address, value);
#elseif java
		untyped __java__("hotmem.java.JavaUnsafe.UNSAFE.putShort({0}, hotmem.java.JavaUnsafe.BYTE_ARRAY_BASE_OFFSET + {1}, (short){2})", this, address, value);
#end
	}

	@:unreflective
	public inline function getU16(address:Int):U16 {
#if (flash || js)
		return hotmem.HotMemory.getU16(this + address);
#elseif cpp
		return untyped __cpp__("*((cpp::UInt16*)({0} + {1}))", this, address);
#elseif java
		return untyped __java__("hotmem.java.JavaUnsafe.UNSAFE.getShort({0}, hotmem.java.JavaUnsafe.BYTE_ARRAY_BASE_OFFSET + {1})& 0xFFFF", this, address);
#else
		return 0;
#end
	}

	@:unreflective
	public inline function setI32(address:Int, value:I32):Void {
#if (flash || js)
		hotmem.HotMemory.setI32(this + address, value);
#elseif cpp
		untyped __cpp__("*((cpp::Int32*)({0} + {1})) = {2}", this, address, value);
#elseif java
		untyped __java__("hotmem.java.JavaUnsafe.UNSAFE.putInt({0}, hotmem.java.JavaUnsafe.BYTE_ARRAY_BASE_OFFSET + {1}, (int){2})", this, address, value);
#end
	}

	@:unreflective
	public inline function getI32(address:Int):I32 {
#if (flash || js)
		return hotmem.HotMemory.getI32(this + address);
#elseif cpp
		return untyped __cpp__("*((cpp::Int32*)({0} + {1}))", this, address);
#elseif java
		return untyped __java__("hotmem.java.JavaUnsafe.UNSAFE.getInt({0}, hotmem.java.JavaUnsafe.BYTE_ARRAY_BASE_OFFSET + {1})", this, address);
#else
		return 0;
#end
	}

	@:unreflective
	public inline function setF32(address:Int, value:F32):Void {
#if (flash || js)
		hotmem.HotMemory.setF32(this + address, value);
#elseif cpp
		untyped __cpp__("*((cpp::Float32*)({0} + {1})) = {2}", this, address, value);
#elseif java
		untyped __java__("hotmem.java.JavaUnsafe.UNSAFE.putFloat({0}, hotmem.java.JavaUnsafe.BYTE_ARRAY_BASE_OFFSET + {1}, (float){2})", this, address, value);
#end
	}

	@:unreflective
	public inline function getF32(address:Int):F32 {
#if (flash || js)
		return hotmem.HotMemory.getF32(this + address);
#elseif cpp
		return untyped __cpp__("*((cpp::Float32*)({0} + {1}))", this, address);
#elseif java
		return untyped __java__("hotmem.java.JavaUnsafe.UNSAFE.getFloat({0}, hotmem.java.JavaUnsafe.BYTE_ARRAY_BASE_OFFSET + {1})", this, address);
#else
		return 0;
#end
	}

}

#end