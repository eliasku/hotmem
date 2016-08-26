package hotmem;

#if (flash||js)
typedef U8 = Int;
#elseif java
typedef U8 = java.StdTypes.Int8;
#elseif cs
typedef U8 = cs.StdTypes.UInt8;
#elseif cpp
typedef U8 = cpp.UInt8;
#end