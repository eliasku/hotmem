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

::foreach TYPES::
	@:unreflective
	public inline function set::TYPE::(offset:Int, value:::TYPE::):Void {
#if (flash || js)
		hotmem.HotMemory.set::TYPE::(this + offset, value);
#elseif cpp
		untyped __cpp__("*((::CPP_POINTER_TYPE::)({0} + {1})) = {2}", this, offset, value);
#end
	}

	@:unreflective
	public inline function get::TYPE::(offset:Int):::TYPE:: {
#if (flash || js)
		return hotmem.HotMemory.get::TYPE::(this + offset);
#elseif cpp
		return untyped __cpp__("*((::CPP_POINTER_TYPE::)({0} + {1}))", this, offset);
#else
		return 0;
#end
	}
::end::
}

#end