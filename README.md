# EducationalBabyGame
(working title)

 An educational mobile app for babies and children.

## Building and Running on Android

### Exporting for Android

Follow the directions here for setting up to export for Android:

https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html

Note that you only need to follow up to "Setting it Up in Godot", and some of that should be configured already

You should then be able to use the Export Preset for Android to create an APK file, or...

### Remote Debug

The Remote Debug option is described here:

https://docs.godotengine.org/en/3.1/tutorials/debug/overview_of_debugging_tools.html#deploy-with-remote-debug

Note that in order for this to work, you must take several steps:

1. Setup for exporting to Android, as described above
2. Enable Developer Mode on your phone: https://developer.android.com/studio/debug/dev-options#enable
3. Enable USB Debugging on your phone: https://developer.android.com/studio/debug/dev-options#Enable-debugging
4. Connect your phone to the PC via a USB cable
5. There should then be the option to run Remote Debug, next to the "Play Current Scene" button