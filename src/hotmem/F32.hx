package hotmem;

#if (flash||js||neko||hl)
typedef F32 = Float;
#elseif java
typedef F32 = Single;
#elseif cs
typedef F32 = Single;
#elseif cpp
typedef F32 = cpp.Float32;
#end