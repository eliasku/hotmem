package hotmem;

#if (flash||js||neko)
typedef ::TYPE:: = ::GENERIC_TYPE::;
#elseif java
typedef ::TYPE:: = ::JAVA_TYPE::;
#elseif cs
typedef ::TYPE:: = ::CS_TYPE::;
#elseif cpp
typedef ::TYPE:: = cpp.::SPECIFIC_TYPE::;
#end