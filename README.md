# hotmem

[![Build Status](https://travis-ci.org/eliasku/hotmem.svg?branch=develop)](https://travis-ci.org/eliasku/hotmem)
[![Build status](https://ci.appveyor.com/api/projects/status/bu04g9dv5bikgfxp?svg=true)](https://ci.appveyor.com/project/eliasku/hotmem)

[![Lang](https://img.shields.io/badge/language-haxe-orange.svg)](http://haxe.org)
[![Version](https://img.shields.io/badge/version-v0.0.3-green.svg)](https://github.com/eliasku/hotmem)
[![Dependencies](https://img.shields.io/badge/dependencies-none-green.svg)](https://github.com/eliasku/hotmem/blob/master/haxelib.json)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](http://opensource.org/licenses/MIT)

Hot memory access for Haxe

Created to provide significantly boosted performance for typed arrays. Reduce amount of memory.

## Targets

| Target | Array | Array<->Bytes | ArrayBytes | HotBytes | Implementation         |
| ------ | -----:| :------------:| ----------:| --------:|-----------------------:|
| cpp    | +     | +             | +          | +        | hxcpp_memory / pointer |
| flash  | +     | +             | +          | +        | Memory Domain          |
| js     | +     | +             | +          | +        | Parallel Typed Arrays  |
| nodejs | +     | +             | +          | +        | Parallel Typed Arrays* |
| cs     | +     | -             | +          | +        | NativeArray_T / Unsafe |
| java   | +     | -             | +          | +        | NativeArray_T / Unsafe |
| neko   | +     | -             | -          | +        | NativeArray_T / String |

Define `-D hotmem_debug` enabling bounds checking, traces and additional asserts

## Usage

Create your static dense fixed-length typed arrays before performance critical operations.

Use `ArrayBytes` if you need access to hot-array memory
For `haxe.io.BytesData` memory use `HotMemory::lock` and `HotBytes`

Targets unification:
- All operations should be type-size aligned.
- All `HotMemory::lock` operations require `HotMemory::unlock` at the end.
- For `flash` target you should be careful with `ApplicationDomain.current.memoryDomain`

## Types

- `hotmem.U8`: 8-bit unsigned int
- `hotmem.U16`: 16-bit unsigned int
- `hotmem.I32`: 32-bit signed int
- `hotmem.F32`: 32-bit floating-point

## Typed Arrays

For each types continuous memory fixed-length array is available (buffer)

- `hotmem.U8Array`: 8-bit unsigned int array
- `hotmem.U16Array`: 16-bit unsigned int array
- `hotmem.I32Array`: 32-bit signed int array
- `hotmem.F32Array`: 32-bit floating-point array

## Array Bytes

Each hot array could be wrapped for memory read/write operations:

```
var view = array.view(?atElement);
view.setU8(bytePosition, value);
view.setU16(bytePosition, value);
view.setI32(bytePosition, value);
view.setF32(bytePosition, value);

value = view.getU8(bytePosition);
value = view.getU16(bytePosition);
value = view.getI32(bytePosition);
value = view.getF32(bytePosition);
```

## Hot Bytes

For platform-specific fast memory access to the `haxe.io.BytesData` content.

## Modify templates and generate the code

`$hotmem> haxelib run hxmake generate`

## TODO:

- More tests
- Missing types: I8, I16, U32, F64
- NodeJS buffers implementation
- More documentation on HotBytes (lock / unlock flow)
- Dox documentation
