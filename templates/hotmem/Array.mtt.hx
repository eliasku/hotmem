package hotmem;

#if cpp
private typedef ::TYPE::ArrayData = haxe.io.BytesData;
#elseif (neko||macro)
private typedef ::TYPE::ArrayData = neko.NativeArray<::TYPE::>;
//#elseif java
//private typedef ::TYPE::ArrayData = haxe.io.BytesData;
#elseif cs
private typedef ::TYPE::ArrayData = cs.NativeArray<::TYPE::>;
#elseif java
private typedef ::TYPE::ArrayData = java.NativeArray<::TYPE::>;
#else
private typedef ::TYPE::ArrayData = Int;
#end

@:unreflective
abstract ::TYPE::Array(::TYPE::ArrayData) from ::TYPE::ArrayData to ::TYPE::ArrayData {

	#if (cs||java||cpp||neko||macro)
	public inline static var NULL:::TYPE::ArrayData = null;
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
		this = @:privateAccess HotMemory.alloc(length::EXPR_LEFT_SHIFT::) ::if (EL_SHIFT > 0)::#if js ::EXPR_RIGHT_SHIFT:: #end::end::;
#elseif cpp
		this = new haxe.io.BytesData();
		cpp.NativeArray.setSize(this, length::EXPR_LEFT_SHIFT::);
#elseif (macro||neko)
		this = neko.NativeArray.alloc(length);
#elseif java
		this = new java.NativeArray(length);
		//this = new haxe.io.BytesData(length::EXPR_LEFT_SHIFT::);
#elseif cs
		this = new cs.NativeArray(length);
#end
	}

	@:unreflective inline public function dispose() {
#if hotmem_debug
		__checkValid();
#end

#if (js||flash)
		@:privateAccess HotMemory.free(this #if js ::EXPR_LEFT_SHIFT:: #end);
		this = 0;
#elseif (cpp||java||cs||macro||neko)
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
#elseif java
		//return JavaUnsafe.UNSAFE.::JAVA_UNSAFE_SET::(this, JavaUnsafe.BYTE_ARRAY_BASE_OFFSET + (index::EXPR_LEFT_SHIFT::), element);
		this[index] = element;
#elseif cs
		this[index] = element;
#elseif (neko||macro)
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
#elseif java
		//return untyped __java__("hotmem.JavaUnsafe.UNSAFE.::JAVA_UNSAFE_GET::({0}, hotmem.JavaUnsafe.BYTE_ARRAY_BASE_OFFSET + ({1}::EXPR_LEFT_SHIFT::))", this, index)::JAVA_UNSAFE_GET_BIT_AND::;
		return this[index];
#elseif cs
		return this[index];
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
		return bytesLength::EXPR_RIGHT_SHIFT::;
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
		return this.length::EXPR_LEFT_SHIFT::;
#elseif cs
		return this.length::EXPR_LEFT_SHIFT::;
#elseif (neko||macro)
		return length::EXPR_LEFT_SHIFT::;
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
		return this::EXPR_LEFT_SHIFT::;
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

		::if (EL_SHIFT > 0)::
		return new HotView(this #if js ::EXPR_LEFT_SHIFT:: #end, atElement::EXPR_LEFT_SHIFT::);
		::else::
		return new HotView(this, atElement);
		::end::
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