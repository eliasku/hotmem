package hotmem;

#if cpp
private typedef ::TYPE::ArrayData = haxe.io.BytesData;
#elseif cs
private typedef ::TYPE::ArrayData = cs.NativeArray<::TYPE::>;
#elseif java
private typedef ::TYPE::ArrayData = java.NativeArray<::TYPE::>;
#else
private typedef ::TYPE::ArrayData = Int;
#end

@:unreflective
abstract ::TYPE::Array(::TYPE::ArrayData) from ::TYPE::ArrayData to ::TYPE::ArrayData {

	@:unreflective
	public var length(get, never):Int;

	@:unreflective
	inline public function new(length:Int) {
#if (flash || js)
		this = @:privateAccess HotMemory.alloc(length::EXPR_LEFT_SHIFT::) ::if (EL_SHIFT > 0)::#if js ::EXPR_RIGHT_SHIFT:: #end::end::;
#elseif cpp
		this = new haxe.io.BytesData();
		cpp.NativeArray.setSize(this, length::EXPR_LEFT_SHIFT::);
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

#if (js || flash)
		@:privateAccess HotMemory.free(this #if js ::EXPR_LEFT_SHIFT:: #end);
#elseif (cpp||java||cs)
		this = null;
#else
		this = 0;
#end
	}

	@:unreflective
	@:arrayAccess inline function set(index:Int, element:::TYPE::) {
#if hotmem_debug
		__checkValid();
		__checkBounds(index);
#end

#if flash
		HotMemory.set::TYPE::((index::EXPR_LEFT_SHIFT::) + this, element);
#elseif js
		HotMemory.set::TYPE::elem(index + this, element);
#elseif cpp
		untyped __cpp__("((::CPP_POINTER_TYPE::){0}->GetBase())[{1}] = {2}", this, index, element);
#elseif (java||cs)
		this[index] = element;
#end
	}

	@:unreflective
	@:arrayAccess inline function get(index:Int):::TYPE:: {
#if hotmem_debug
		__checkValid();
		__checkBounds(index);
#end

#if flash
		return HotMemory.get::TYPE::((index::EXPR_LEFT_SHIFT::) + this);
#elseif js
		return HotMemory.get::TYPE::elem(index + this);
#elseif cpp
		return untyped __cpp__("((::CPP_POINTER_TYPE::){0}->GetBase())[{1}]", this, index);
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
		return HotMemory.getI32(this - 4)::EXPR_RIGHT_SHIFT::;
#elseif js
		return HotMemory.getI32((this::EXPR_LEFT_SHIFT::) - 4)::EXPR_RIGHT_SHIFT::;
#elseif cpp
		return this.length::EXPR_RIGHT_SHIFT::;
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

		::if (EL_SHIFT > 0)::
		return new HotView(this #if js ::EXPR_LEFT_SHIFT:: #end, atElement::EXPR_LEFT_SHIFT::);
		::else::
		return new HotView(this, atElement);
		::end::
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