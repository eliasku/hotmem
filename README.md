# hotmem

[![Build Status](https://travis-ci.org/eliasku/hotmem.svg?branch=develop)](https://travis-ci.org/eliasku/hotmem)
[![Build status](https://ci.appveyor.com/api/projects/status/bu04g9dv5bikgfxp?svg=true)](https://ci.appveyor.com/project/eliasku/hotmem)

[![Lang](https://img.shields.io/badge/language-haxe-orange.svg)](http://haxe.org)
[![Version](https://img.shields.io/badge/version-v0.0.2-green.svg)](https://github.com/eliasku/hotmem)
[![Dependencies](https://img.shields.io/badge/dependencies-none-green.svg)](https://github.com/eliasku/hotmem/blob/master/haxelib.json)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](http://opensource.org/licenses/MIT)

Hot memory access for Haxe

## Targets

| Target | Arrays | Hot View | Bytes View | Implementation         |
| ------ | ------:| :-------:| ----------:| ----------------------:|
| cpp    | +        | +      | +          | hxcpp_memory / pointer |
| flash  | +        | +      | +          | Memory Domain          |
| js     | +        | +      | +          | Parallel Typed Arrays  |
| nodejs | +        | +      | +          | Parallel Typed Arrays* |
| cs     | +        | -      | -          | NativeArray            |
| java   | +        | -      | -          | NativeArray            |
| neko   | +        | -      | -          | neko build-in          |

Define `-D hotmem_debug` enabling bounds checking, traces and additional asserts

## Usage

Create your static dense fixed-length typed arrays before performance critical operations.

Use `HotView` if different value-type access required

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

## Hot View

Each array could be wrapped for memory read/write operations:

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

## Data View

As Hot-View you able to `lock` any `haxe.io.BytesData`:

## Modify templates and generate the code

`$hotmem> haxelib run hxmake generate`

## TODO:

- More tests
- NodeJS implementation
- Types: I8, I16, U32, F64
- Java / CS implementation for hot/bytes view
- General fallback for other dynamic targets (`macro` as well)
- More documentation on BytesView / lock / unlock flow
- Dox documentation
