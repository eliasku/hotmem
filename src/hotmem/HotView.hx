package hotmem;

#if (cpp||js||flash)

private typedef HotViewData = #if cpp cpp.RawPointer<cpp.Char> #else Int #end;

@:notNull
@:structAccess
@:unreflective
abstract HotView(HotViewData) from HotViewData to HotViewData {

#if cpp
	@:unreflective
	@:generic inline function new<T>(buffer:haxe.io.BytesData, bytesOffset:Int = 0) {
		this = untyped __cpp__("({0}->GetBase()+{1})", buffer, bytesOffset);
	}
#else
	inline function new(address:Int, bytesOffset:Int = 0) {
		this = address + bytesOffset;
	}
#end


	@:unreflective
	public inline function setU8(offset:Int, value:U8):Void {
#if (flash || js)
		hotmem.HotMemory.setU8(this + offset, value);
#elseif cpp
		untyped __cpp__("*((cpp::UInt8*)({0} + {1})) = {2}", this, offset, value);
#end
	}

	@:unreflective
	public inline function getU8(offset:Int):U8 {
#if (flash || js)
		return hotmem.HotMemory.getU8(this + offset);
#elseif cpp
		return untyped __cpp__("*((cpp::UInt8*)({0} + {1}))", this, offset);
#else
		return 0;
#end
	}

	@:unreflective
	public inline function setU16(offset:Int, value:U16):Void {
#if (flash || js)
		hotmem.HotMemory.setU16(this + offset, value);
#elseif cpp
		untyped __cpp__("*((cpp::UInt16*)({0} + {1})) = {2}", this, offset, value);
#end
	}

	@:unreflective
	public inline function getU16(offset:Int):U16 {
#if (flash || js)
		return hotmem.HotMemory.getU16(this + offset);
#elseif cpp
		return untyped __cpp__("*((cpp::UInt16*)({0} + {1}))", this, offset);
#else
		return 0;
#end
	}

	@:unreflective
	public inline function setI32(offset:Int, value:I32):Void {
#if (flash || js)
		hotmem.HotMemory.setI32(this + offset, value);
#elseif cpp
		untyped __cpp__("*((cpp::Int32*)({0} + {1})) = {2}", this, offset, value);
#end
	}

	@:unreflective
	public inline function getI32(offset:Int):I32 {
#if (flash || js)
		return hotmem.HotMemory.getI32(this + offset);
#elseif cpp
		return untyped __cpp__("*((cpp::Int32*)({0} + {1}))", this, offset);
#else
		return 0;
#end
	}

	@:unreflective
	public inline function setF32(offset:Int, value:F32):Void {
#if (flash || js)
		hotmem.HotMemory.setF32(this + offset, value);
#elseif cpp
		untyped __cpp__("*((cpp::Float32*)({0} + {1})) = {2}", this, offset, value);
#end
	}

	@:unreflective
	public inline function getF32(offset:Int):F32 {
#if (flash || js)
		return hotmem.HotMemory.getF32(this + offset);
#elseif cpp
		return untyped __cpp__("*((cpp::Float32*)({0} + {1}))", this, offset);
#else
		return 0;
#end
	}

}

#end