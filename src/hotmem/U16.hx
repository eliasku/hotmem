package hotmem;

#if (flash||js||neko||hl)
typedef U16 = Int;
#elseif java
typedef U16 = Int;
#elseif cs
typedef U16 = Int;
#elseif cpp
typedef U16 = cpp.UInt16;
#end