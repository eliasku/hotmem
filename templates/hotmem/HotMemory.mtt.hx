package hotmem;

import haxe.io.BytesData;
import haxe.io.Bytes;

@:final
@:unreflective
class HotMemory {

	static inline var MIN_SIZE_BYTES:Int = 4 * 1024 * 1024;

	/** HotBytes functionality **/
#if flash
	static var _viewStack:Array<BytesData> = [];
	static var _viewCurrent:BytesData;

	public static function lock(data:BytesData):HotBytes {
		_viewStack.push(data);
		return selectView(data);
	}

	public static function unlock():HotBytes {
		#if flash
		_viewStack.pop();
		var top = _viewStack.length > 0 ? _viewStack[_viewStack.length - 1] : null;
		if(top != null) {
			selectView(_viewCurrent);
		}
		else {
			restore();
		}
		#end
		return HotBytes.NULL;
	}

	static function selectView(data:BytesData):HotBytes {
		data.endian = flash.utils.Endian.LITTLE_ENDIAN;
		if(data.length < 1024) {
			data.length = 1024;
		}
		flash.system.ApplicationDomain.currentDomain.domainMemory = data;
		return new HotBytes(0);
	}
#else
	inline public static function lock(data:BytesData):HotBytes {
	#if (cpp||neko||java||cs||hl)
		return new HotBytes(data);
	#elseif js
		return new HotBytes(_bytesView.select(data));
	#end
	}

	inline public static function unlock():HotBytes {
		return HotBytes.NULL;
	}
#end

#if js
	static function __init__() {
		untyped __js__("var HOT_U8, HOT_U16, HOT_I32, HOT_F32");
	}
	static var _bytesView:hotmem.js.HotBytesImpl = new hotmem.js.HotBytesImpl();
#end

#if flash
	public static var U8(default, null):flash.utils.ByteArray;
#end

	/** Heap Bytes **/
	public static var bytes(default, null):Bytes;

	/** Heap size in bytes **/
	public static var size(default, null):Int = 0;

#if (flash||js)
	static var _nextLocation:Int = 0;
	static var _freeStart:Array<Int> = [];
	static var _freeLength:Array<Int> = [];

#end
	static var _requiredBytesLength:Int = 0;

	static public function require(sizeMb:Int) {
		var bytesLength = sizeMb * 1000 * 1000;
		_requiredBytesLength += bytesLength;
	}

	static function ensure(bytesLength:Int) {
		if(bytesLength >= size) {
			grow(bytesLength);
		}
	}

	static function grow(bytesLength:Int) {
		if(bytesLength < MIN_SIZE_BYTES) {
			bytesLength = MIN_SIZE_BYTES;
		}
		if(bytesLength < _requiredBytesLength) {
			bytesLength = _requiredBytesLength;
		}
		if(bytesLength & 0x3 != 0) {
			bytesLength = (bytesLength + 4) & (~0x3);
		}
#if flash
		var old = bytes;
		bytes = haxe.io.Bytes.alloc(bytesLength);
		if(old != null) {
			bytes.blit(0, old, 0, old.length);
		}
		U8 = bytes.getData();
		restore();
#elseif js
		var old = bytes;
		var baseBuffer = new js.html.Uint8Array(bytesLength);
		untyped __js__("HOT_U8 = {0};", baseBuffer);
		untyped __js__("HOT_F32 = new Float32Array(HOT_U8.buffer)");
		untyped __js__("HOT_I32 = new Int32Array(HOT_U8.buffer)");
		untyped __js__("HOT_U16 = new Uint16Array(HOT_U8.buffer);");
		bytes = Bytes.ofData(baseBuffer.buffer);
		if(old != null) {
			bytes.blit(0, old, 0, old.length);
		}
#end
		size = bytesLength;
	}

	/** Restore hot memory access **/
	@:extern inline static public function restore() {
#if flash
		flash.Memory.select(U8);
#end
	}

#if (flash||js)
	/** Allocate hot memory range of size `bytesLength` **/
	static function alloc(bytesLength:Int):Int {
		var bufferLocation = _nextLocation;
		var bytesOffset = bufferLocation + 4;
		ensure(bytesOffset + bytesLength);
		setI32(bufferLocation, bytesLength);
		_nextLocation = bytesOffset + bytesLength;
		if(_nextLocation & 0x3 != 0) {
			#if hotmem_debug
			trace("[hotmem] RE-ALIGN: " + StringTools.hex(_nextLocation));
			#end
			_nextLocation = (_nextLocation + 4) & (~0x3);
			#if hotmem_debug
			trace("[hotmem] TO: " + StringTools.hex(_nextLocation));
			#end
		}
//_nextLocation = ((_nextLocation + 3) >> 2) << 2;
		#if hotmem_debug
		trace("[hotmem] Allocated " + bytesLength + " bytes");
		trace("[hotmem] Heap position " + Std.int(_nextLocation / 1000000) + " mb");
		#end
		return bytesOffset;
	}

	/** Free hot memory at address **/
	static function free(address:Int) {
		var bytesOffset = address - 4;
		_freeStart.push(bytesOffset);
		_freeLength.push(getI32(bytesOffset) + 4);
	}

#if hotmem_debug
	static function __checkBounds(address:Int) {
		if(address < 0 || address >= size) throw "[hotmem] bad adress: " + address + ", size: " + size;
	}
#end

::foreach TYPES::

	/** Set ::SPECIFIC_TYPE:: value at address **/
	@:extern inline static public function set::TYPE::(address:Int, value:::TYPE::):Void {
#if hotmem_debug
		__checkBounds(address);
#end

#if flash
		flash.Memory.::FLASH_MEM_SET::(address, value);
#elseif asm_js
		untyped __js__("HOT_::TYPE::[((({0})|0)::EXPR_RIGHT_SHIFT::)|0] = ::PRE_ASMJS::({1})::POST_ASMJS::", address, value);
#elseif js
		untyped __js__("HOT_::TYPE::[({0})::EXPR_RIGHT_SHIFT::] = {1}", address, value);
#end
	}

	/** Get ::SPECIFIC_TYPE:: value at address **/
	@:extern inline static public function get::TYPE::(address:Int):::TYPE:: {
#if hotmem_debug
		__checkBounds(address);
#end

#if flash
		return flash.Memory.::FLASH_MEM_GET::(address);
#elseif asm_js
		return untyped __js__("(::PRE_ASMJS::HOT_::TYPE::[((({0})|0)::EXPR_RIGHT_SHIFT::)|0]::POST_ASMJS::)", address);
#elseif js
		return untyped __js__("HOT_::TYPE::[({0})::EXPR_RIGHT_SHIFT::]", address);
#end
	}

	/** Get ::SPECIFIC_TYPE:: value at typed index **/
	@:extern inline static public function set::TYPE::elem(index:Int, value:::TYPE::):Void {
#if hotmem_debug
		__checkBounds(index::EXPR_LEFT_SHIFT::);
#end

#if flash
		flash.Memory.::FLASH_MEM_SET::(index::EXPR_LEFT_SHIFT::, value);
#elseif asm_js
		untyped __js__("HOT_::TYPE::[({0})|0] = ::PRE_ASMJS::({1})::POST_ASMJS::", index, value);
#elseif js
		untyped __js__("HOT_::TYPE::[{0}] = {1}", index, value);
#end
	}

	/** Set ::SPECIFIC_TYPE:: value at typed index **/
	@:extern inline static public function get::TYPE::elem(index:Int):::TYPE:: {
#if hotmem_debug
		__checkBounds(index::EXPR_LEFT_SHIFT::);
#end

#if flash
		return flash.Memory.::FLASH_MEM_GET::(index::EXPR_LEFT_SHIFT::);
#elseif asm_js
		return untyped __js__("(::PRE_ASMJS::HOT_::TYPE::[({0})|0]::POST_ASMJS::)", index);
#elseif js
		return untyped __js__("HOT_::TYPE::[{0}]", index);
#end
	}

::end::

#end
}