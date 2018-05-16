package hotmem;

#if cpp
private typedef F32ArrayData = haxe.io.BytesData;
#elseif neko
private typedef F32ArrayData = neko.NativeArray<F32>;
//#elseif java
//private typedef F32ArrayData = haxe.io.BytesData;
#elseif cs
private typedef F32ArrayData = cs.NativeArray<F32>;
#elseif java
private typedef F32ArrayData = java.NativeArray<F32>;
#else
private typedef F32ArrayData = Int;
#end

@:unreflective
abstract F32Array(F32ArrayData) from F32ArrayData to F32ArrayData {

	#if (cs||java||cpp||neko)
	public inline static var NULL:F32ArrayData = null;
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
		this = @:privateAccess HotMemory.alloc(length << 2) #if js  >> 2 #end;
#elseif cpp
		this = new haxe.io.BytesData();
		cpp.NativeArray.setSize(this, length << 2);
#elseif neko
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
		@:privateAccess HotMemory.free(this #if js  << 2 #end);
		this = 0;
#elseif (cpp||java||cs||neko)
		this = null;
#else
		this = 0;
#end
	}

	@:unreflective
	@:arrayAccess inline function set(index:Int, element:F32) {
#if hotmem_debug
		__checkValid();
		__checkBounds(index);
#end

#if flash
		HotMemory.setF32((index << 2) + this, element);
#elseif js
		HotMemory.setF32elem(index + this, element);
#elseif cpp
		untyped __cpp__("((cpp::Float32*){0}->GetBase())[{1}] = {2}", this, index, element);
#elseif java
		this[index] = element;
#elseif cs
		this[index] = element;
		//hotmem.cs.UnsafeBytes.setF32(this, index << 2, element);
#elseif neko
		this[index] = element;
#end
	}

	@:unreflective
	@:arrayAccess inline function get(index:Int):F32 {
#if hotmem_debug
		__checkValid();
		__checkBounds(index);
#end

#if flash
		return HotMemory.getF32((index << 2) + this);
#elseif js
		return HotMemory.getF32elem(index + this);
#elseif cpp
		return untyped __cpp__("((cpp::Float32*){0}->GetBase())[{1}]", this, index);
#elseif java
		return this[index];
#elseif cs
		return this[index];
		//return hotmem.cs.UnsafeBytes.getF32(this, index << 2);
#elseif neko
		return this[index];
#else
		return 0;
#end
	}

	@:unreflective
	inline function get_length():Int {
#if (java||cs)
		return this.length;
#elseif neko
		return neko.NativeArray.length(this);
#else
		return bytesLength >> 2;
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
		return this.length << 2;
#elseif cs
		return this.length << 2;
#elseif neko
		return length << 2;
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
		return this << 2;
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
		
		return new ArrayBytes(this #if js  << 2 #end);
		
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