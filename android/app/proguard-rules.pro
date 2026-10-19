# The Google Mobile Ads SDK starts WorkManager, whose Room database is
# created by reflection; R8 would strip the generated class and the app
# would crash on launch in release builds.
-keep class * extends androidx.room.RoomDatabase { <init>(); }
