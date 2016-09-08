package hotmem.js;

#if js

import js.html.ArrayBuffer;
import js.html.Float32Array;
import js.html.Uint16Array;
import js.html.Uint32Array;
import js.html.Uint8Array;

@:final
class JsBytesView {

	var data:ArrayBuffer;

	var arrayByte:Uint8Array;
	var arrayUShort:Uint16Array;
	var arrayUInt:Uint32Array;
	var arrayFloat:Float32Array;

	public function new() {}

	public function select(value:ArrayBuffer):JsBytesView {
		if (data == value) {
			return this;
		}
		if (value != null) {
			arrayByte = new Uint8Array(value);
			arrayUShort = new Uint16Array(value);
			arrayUInt = new Uint32Array(value);
			arrayFloat = new Float32Array(value);
		}
		else {
			arrayByte = null;
			arrayUShort = null;
			arrayUInt = null;
			arrayFloat = null;
		}
		data = value;
		return this;
	}

	@:extern public inline function getU8(address:Int):Int {
		return arrayByte[address];
	}

	@:extern public inline function getU16(address:Int):Int {
		return arrayUShort[address >> 1];
	}

	@:extern public inline function getU32(address:Int):Int {
		return arrayUInt[address >> 2] & 0xFFFFFFFF;
	}

	@:extern public inline function getF32(address:Int):Float {
		return arrayFloat[address >> 2];
	}

	@:extern public inline function setU8(address:Int, value:Int):Void {
		arrayByte[address] = value;
	}

	@:extern public inline function setU16(address:Int, value:Int):Void {
		arrayUShort[address >> 1] = value;
	}

	@:extern public inline function setU32(address:Int, value:Int):Void {
		arrayUInt[address >> 2] = value;
	}

	@:extern public inline function setF32(address:Int, value:Float):Void {
		arrayFloat[address >> 2] = value;
	}
}

#end