package hotmem;

#if cpp
private typedef I32ArrayData = haxe.io.BytesData;
#elseif cs
private typedef I32ArrayData = cs.NativeArray<I32>;
#elseif java
private typedef I32ArrayData = java.NativeArray<I32>;
#else
private typedef I32ArrayData = Int;
#end

@:unreflective
abstract I32Array(I32ArrayData) from I32ArrayData to I32ArrayData {

	#if (cs||java||cpp)
	public inline static var NULL = null;
	#else
	public inline static var NULL:Int = 0;
	#end

	@:unreflective
	public var length(get, never):Int;

	@:unreflective
	inline public function new(length:Int) {
#if (flash || js)
		this = @:privateAccess HotMemory.alloc(length << 2) #if js  >> 2 #end;
#elseif cpp
		this = new haxe.io.BytesData();
		cpp.NativeArray.setSize(this, length << 2);
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
		@:privateAccess HotMemory.free(this #if js  << 2 #end);
		this = 0;
#elseif (cpp||java||cs)
		this = null;
#else
		this = 0;
#end
	}

	@:unreflective
	@:arrayAccess inline function set(index:Int, element:I32) {
#if hotmem_debug
		__checkValid();
		__checkBounds(index);
#end

#if flash
		HotMemory.setI32((index << 2) + this, element);
#elseif js
		HotMemory.setI32elem(index + this, element);
#elseif cpp
		untyped __cpp__("((cpp::Int32*){0}->GetBase())[{1}] = {2}", this, index, element);
#elseif (java||cs)
		this[index] = element;
#end
	}

	@:unreflective
	@:arrayAccess inline function get(index:Int):I32 {
#if hotmem_debug
		__checkValid();
		__checkBounds(index);
#end

#if flash
		return HotMemory.getI32((index << 2) + this);
#elseif js
		return HotMemory.getI32elem(index + this);
#elseif cpp
		return untyped __cpp__("((cpp::Int32*){0}->GetBase())[{1}]", this, index);
#elseif (java||cs)
		return this[index];
#else
		return 0;
#end
	}

	@:unreflective
	inline function get_length():Int {
#if hotmem_debug
		__checkValid();
#end

#if flash
		return HotMemory.getI32(this - 4) >> 2;
#elseif js
		return HotMemory.getI32((this << 2) - 4) >> 2;
#elseif cpp
		return this.length >> 2;
#elseif (java||cs)
		return this.length;
#else
		return 0;
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

		
		return new HotView(this #if js  << 2 #end, atElement << 2);
		
	}
#end

#if hotmem_debug
	function __checkBounds(index:Int) {
		if(index < 0 || index >= length) throw 'index out of bounds [index: $index, length: $length]';
	}

	function __checkValid() {
#if (js||cs||java||cpp)
		if(this == null) throw "Array is not created";
#else
		if(this == 0) throw "Array is not created";
#end
	}
#end
}