# hotmem

Hot memory access for Haxe

## Targets

| Target | Data View | Require preallocation | Implementation         |
| ------ |:---------:| ---------------------:| ----------------------:|
| cpp    | +         | -                     | hxcpp_memory           |
| flash  | +         | +                     | Memory Domain          |
| js     | +         | +                     | Parallel Typed Arrays  |
| nodejs | +         | +                     | Parallel Typed Arrays* |
| cs     | -         | -                     | NativeArray            |
| java   | -         | -                     | NativeArray            |

## Usage

Initialize HotMemory storage just for all targets generalization (could be improved later)
```
HotMemory.initialize(sizeInMb);
```

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

## Data View

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

## Modify templates and generate the code

`$hotmem> haxelib run hxmake generate`

## TODO:

- Tests + CI
- NodeJS implementation
- Types: I8, I16, U32, F64
- Java / CS implementation and memory view
- General fallback for other dynamic targets (even `macro`)
