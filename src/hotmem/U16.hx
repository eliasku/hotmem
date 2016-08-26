package hotmem;

#if (flash||js)
typedef U16 = Int;
#elseif java
typedef U16 = java.StdTypes.Int16;
#elseif cs
typedef U16 = cs.StdTypes.UInt16;
#elseif cpp
typedef U16 = cpp.UInt16;
#end