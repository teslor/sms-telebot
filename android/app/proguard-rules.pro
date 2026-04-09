# Prevent renaming mail and activation classes
-keep class com.sun.mail.** { *; }
-keep class jakarta.mail.** { *; }
-keep class com.sun.activation.** { *; }
-keep class jakarta.activation.** { *; }

# Suppress warnings about missing classes in mail libraries
-dontwarn com.sun.mail.**
-dontwarn jakarta.mail.**

# Suppress warnings about missing annotations
-dontwarn com.google.errorprone.annotations.**

# Tell R8 not to modify resource files used for protocol lookup
-adaptresourcefilecontents META-INF/javamail.providers
-adaptresourcefilecontents META-INF/mailcap
