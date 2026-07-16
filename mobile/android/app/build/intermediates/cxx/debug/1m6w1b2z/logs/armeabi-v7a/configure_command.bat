@echo off
"C:\\Users\\legion\\AppData\\Local\\Android\\Sdk\\cmake\\3.22.1\\bin\\cmake.exe" ^
  "-HC:\\src_flutter\\flutter\\packages\\flutter_tools\\gradle\\src\\main\\scripts" ^
  "-DCMAKE_SYSTEM_NAME=Android" ^
  "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON" ^
  "-DCMAKE_SYSTEM_VERSION=24" ^
  "-DANDROID_PLATFORM=android-24" ^
  "-DANDROID_ABI=armeabi-v7a" ^
  "-DCMAKE_ANDROID_ARCH_ABI=armeabi-v7a" ^
  "-DANDROID_NDK=C:\\Users\\legion\\AppData\\Local\\Android\\sdk\\ndk\\28.2.13676358" ^
  "-DCMAKE_ANDROID_NDK=C:\\Users\\legion\\AppData\\Local\\Android\\sdk\\ndk\\28.2.13676358" ^
  "-DCMAKE_TOOLCHAIN_FILE=C:\\Users\\legion\\AppData\\Local\\Android\\sdk\\ndk\\28.2.13676358\\build\\cmake\\android.toolchain.cmake" ^
  "-DCMAKE_MAKE_PROGRAM=C:\\Users\\legion\\AppData\\Local\\Android\\Sdk\\cmake\\3.22.1\\bin\\ninja.exe" ^
  "-DCMAKE_LIBRARY_OUTPUT_DIRECTORY=D:\\Minor Project\\Code\\sajilo-yatra\\mobile\\android\\app\\build\\intermediates\\cxx\\debug\\1m6w1b2z\\obj\\armeabi-v7a" ^
  "-DCMAKE_RUNTIME_OUTPUT_DIRECTORY=D:\\Minor Project\\Code\\sajilo-yatra\\mobile\\android\\app\\build\\intermediates\\cxx\\debug\\1m6w1b2z\\obj\\armeabi-v7a" ^
  "-BD:\\Minor Project\\Code\\sajilo-yatra\\mobile\\android\\app\\.cxx\\debug\\1m6w1b2z\\armeabi-v7a" ^
  -GNinja ^
  -Wno-dev ^
  --no-warn-unused-cli ^
  "-DCMAKE_BUILD_TYPE=debug"
