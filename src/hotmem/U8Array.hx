package hotmem;

#if cpp
private typedef U8ArrayData = haxe.io.BytesData;
//#elseif java
//private typedef U8ArrayData = haxe.io.BytesData;
#elseif cs
private typedef U8ArrayData = cs.NativeArray<U8>;
#elseif java
private typedef U8ArrayData = java.NativeArray<U8>;
#else
private typedef U8ArrayData = Int;
#end

@:unreflective
abstract U8Array(U8ArrayData) from U8ArrayData to U8ArrayData {

	#if (cs||java||cpp)
	public inline static var NULL:U8ArrayData = null;
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
#if (flash || js)
		this = @:privateAccess HotMemory.alloc(length) ;
#elseif cpp
		this = new haxe.io.BytesData();
		cpp.NativeArray.setSize(this, length);
#elseif java
		this = new java.NativeArray(length);
		//this = new haxe.io.BytesData(length);
#elseif cs
		this = new cs.NativeArray(length);
#end
	}

	@:unreflective inline public function dispose() {
#if hotmem_debug
		__checkValid();
#end

#if (js||flash)
		@:privateAccess HotMemory.free(this #if js  #end);
		this = 0;
#elseif (cpp||java||cs)
		this = null;
#else
		this = 0;
#end
	}

	@:unreflective
	@:arrayAccess inline function set(index:Int, element:U8) {
#if hotmem_debug
		__checkValid();
		__checkBounds(index);
#end

#if flash
		HotMemory.setU8((index) + this, element);
#elseif js
		HotMemory.setU8elem(index + this, element);
#elseif cpp
		untyped __cpp__("((cpp::UInt8*){0}->GetBase())[{1}] = {2}", this, index, element);
#elseif java
		//return JavaUnsafe.UNSAFE.putByte(this, JavaUnsafe.BYTE_ARRAY_BASE_OFFSET + (index), element);
		this[index] = element;
#elseif cs
		this[index] = element;
#end
	}

	@:unreflective
	@:arrayAccess inline function get(index:Int):U8 {
#if hotmem_debug
		__checkValid();
		__checkBounds(index);
#end

#if flash
		return HotMemory.getU8((index) + this);
#elseif js
		return HotMemory.getU8elem(index + this);
#elseif cpp
		return untyped __cpp__("((cpp::UInt8*){0}->GetBase())[{1}]", this, index);
#elseif java
		//return untyped __java__("hotmem.JavaUnsafe.UNSAFE.getByte({0}, hotmem.JavaUnsafe.BYTE_ARRAY_BASE_OFFSET + ({1}))", this, index)& 0xFF;
		return this[index];
#elseif cs
		return this[index];
#else
		return 0;
#end
	}

	@:unreflective
	inline function get_length():Int {
		return bytesLength;
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
		return this.length;
#elseif cs
		// TODO:
		return this.length;
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
		return this;
#else
		return 0;
#end
	// TODO: cs
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
//#elseif java
//		return this;
#else
		return null;
		//TODO: java & cs
#end
	}

#if (js||flash||cpp)
	@:unreflective
	@:access(hotmem.HotView)
	inline public function view(atElement:Int = 0):HotView {
#if hotmem_debug
		__checkBounds(atElement);
		__checkValid();
#end

		
		return new HotView(this, atElement);
		
	}
#end

#if hotmem_debug
	function __checkBounds(index:Int) {
		if(index < 0 || index >= length) throw 'index out of bounds [index: $index, length: $length]';
	}

	function __checkValid() {
		if(this == NULL) throw "Array is not created";
	}
#end
}