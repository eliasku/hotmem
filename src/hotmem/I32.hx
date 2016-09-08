package hotmem;

#if (flash||js||neko)
typedef I32 = Int;
#elseif java
typedef I32 = Int;
#elseif cs
typedef I32 = Int;
#elseif cpp
typedef I32 = cpp.Int32;
#end