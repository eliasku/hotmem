package hotmem;

#if cpp
private typedef U16ArrayData = haxe.io.BytesData;
#elseif (neko||macro)
private typedef U16ArrayData = neko.NativeArray<U16>;
//#elseif java
//private typedef U16ArrayData = haxe.io.BytesData;
#elseif cs
private typedef U16ArrayData = cs.NativeArray<U16>;
#elseif java
private typedef U16ArrayData = java.NativeArray<U16>;
#else
private typedef U16ArrayData = Int;
#end

@:unreflective
abstract U16Array(U16ArrayData) from U16ArrayData to U16ArrayData {

	#if (cs||java||cpp||neko||macro)
	public inline static var NULL:U16ArrayData = null;
	#else
	public inline static var NULL:Int = 0;
	#end

	@:unreflective
	public var length(get, never):Int;

	@:unreflective
	public var bytesLength(get, never):Int;

	@:unreflective
	public var bytesOffset(get, never):Int;

	@:unreflective
	public var bytesData(get, never):haxe.io.BytesData;

	@:unreflective
	inline public function new(length:Int) {
#if (flash||js)
		this = @:privateAccess HotMemory.alloc(length << 1) #if js  >> 1 #end;
#elseif cpp
		this = new haxe.io.BytesData();
		cpp.NativeArray.setSize(this, length << 1);
#elseif (macro||neko)
		this = neko.NativeArray.alloc(length);
#elseif java
		this = new java.NativeArray(length);
#elseif cs
		this = new cs.NativeArray(length);
#end
	}

	@:unreflective inline public function dispose() {
#if hotmem_debug
		__checkValid();
#end

#if (js||flash)
		@:privateAccess HotMemory.free(this #if js  << 1 #end);
		this = 0;
#elseif (cpp||java||cs||macro||neko)
		this = null;
#else
		this = 0;
#end
	}

	@:unreflective
	@:arrayAccess inline function set(index:Int, element:U16) {
#if hotmem_debug
		__checkValid();
		__checkBounds(index);
#end

#if flash
		HotMemory.setU16((index << 1) + this, element);
#elseif js
		HotMemory.setU16elem(index + this, element);
#elseif cpp
		untyped __cpp__("((cpp::UInt16*){0}->GetBase())[{1}] = {2}", this, index, element);
#elseif java
		this[index] = element;
#elseif cs
		this[index] = element;
		//hotmem.cs.UnsafeBytes.setU16(this, index << 1, element);
#elseif (neko||macro)
		this[index] = element;
#end
	}

	@:unreflective
	@:arrayAccess inline function get(index:Int):U16 {
#if hotmem_debug
		__checkValid();
		__checkBounds(index);
#end

#if flash
		return HotMemory.getU16((index << 1) + this);
#elseif js
		return HotMemory.getU16elem(index + this);
#elseif cpp
		return untyped __cpp__("((cpp::UInt16*){0}->GetBase())[{1}]", this, index);
#elseif java
		return this[index];
#elseif cs
		return this[index];
		//return hotmem.cs.UnsafeBytes.getU16(this, index << 1);
#elseif (neko||macro)
		return this[index];
#else
		return 0;
#end
	}

	@:unreflective
	inline function get_length():Int {
#if (java||cs)
		return this.length;
#elseif (neko||macro)
		return neko.NativeArray.length(this);
#else
		return bytesLength >> 1;
#end
	}

	@:unreflective
	inline function get_bytesLength():Int {
#if hotmem_debug
		__checkValid();
#end

#if (flash||js)
		return HotMemory.getI32(bytesOffset - 4);
#elseif cpp
		return this.length;
#elseif java
		//return this.length;
		return this.length << 1;
#elseif cs
		return this.length << 1;
#elseif (neko||macro)
		return length << 1;
#else
		return 0;
#end
	}

	@:unreflective
	inline function get_bytesOffset():Int {
#if hotmem_debug
		__checkValid();
#end

#if flash
		return this;
#elseif js
		return this << 1;
#else
		return 0;
#end
	}

	@:unreflective
	inline function get_bytesData():haxe.io.BytesData {
#if hotmem_debug
		__checkValid();
#end

#if (js||flash)
		return HotMemory.bytes.getData();
#elseif cpp
		return this;
#else
		return null;
#end
	}

#if (js||flash||cpp||java||cs)
	@:unreflective
	@:access(hotmem.ArrayBytes)
	inline public function getArrayBytes():ArrayBytes {
#if hotmem_debug
		__checkValid();
#end

#if cs
		return new ArrayBytes(hotmem.cs.UnsafeBytes.getPtr(this));
#else
		
		return new ArrayBytes(this #if js  << 1 #end);
		
#end
	}
#end

	inline public function getObjectSize():Int {
		return bytesLength + 4;
	}

#if hotmem_debug
	function __checkBounds(index:Int) {
		if(index < 0 || index >= length) throw 'index out of bounds [index: $index, length: $length]';
	}

	function __checkValid() {
		if(this == NULL) throw "Array is not created";
	}
#end
}