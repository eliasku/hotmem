package hotmem;

#if js
private typedef BytesViewData = hotmem.js.JsBytesView;
#elseif flash
private typedef BytesViewData = Int;
#else
private typedef BytesViewData = haxe.io.BytesData;
#end

abstract BytesView(BytesViewData) {

#if flash
	public inline static var NULL:BytesView = new BytesView(0);
#else
	public inline static var NULL:BytesView = new BytesView(null);
#end

	inline public function new(data:BytesViewData) {
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
#end
	}

	public inline function setU32(address:Int, value:Int) {
#if cpp
		untyped __global__.__hxcpp_memory_set_ui32(this, address, value);
#elseif js
		this.setU32(address, value);
#elseif flash
		flash.Memory.setI32(address, value);
#end
	}

	public inline function setU16(address:Int, value:U16) {
#if cpp
		untyped __global__.__hxcpp_memory_set_ui16(this, address, value);
#elseif js
		this.setU16(address, value);
#elseif flash
		flash.Memory.setI16(address, value);
#end
	}

	public inline function setU8(address:Int, value:U8) {
#if cpp
		untyped this[address] = value;
#elseif js
		this.setU8(address, value);
#elseif flash
		flash.Memory.setByte(address, value);
#end
	}

	public inline function getF32(address:Int):F32 {
#if cpp
		return untyped __global__.__hxcpp_memory_get_float(this, address);
#elseif js
		return this.getF32(address);
#elseif flash
		return flash.Memory.getFloat(address);
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
#else
		return 0;
#end
	}

	public inline function getU8(address:Int):U8 {
#if cpp
		return untyped this[address];
#elseif js
		return this.getU8(address);
#elseif flash
		return flash.Memory.getByte(address);
#else
		return 0;
#end
	}
}
