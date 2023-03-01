
# Whisper Flutter Demo

This repository demonstrates how to use the whisper-dart package to perform voice separation in a Flutter application. Before proceeding, please note that there are still some limitations in Whisper.

## Limitations

-   You can only use a 30-second file or smaller, or you will have to chunk larger files.
-   You must use .wav formatted files.
-   **It takes a lot of time to produce the separated audio.**

## Requirements

-   Flutter SDK
-   Kotlin 1.3.50 or later
-   Android API Level 21 or later

## Steps to Run the Demo

1.  Create a new Flutter project.
    
2.  Copy the `jniLibs` folder from `android/app/src/main/jniLibs` in this repository to your project's `android/app/src/main` folder.
    
3.  Add the following lines to your app-level `build.gradle` file:
    
	    kotlinOptions {

		    jvmTarget = '1.8'

	    }
    
      
    
	    sourceSets {

		    main.java.srcDirs += 'src/main/kotlin'

		    main.jniLibs.srcDirs = ['src/main/jniLibs']

	    }

    
    If you are using an older version of Gradle, use this instead:
    
 		sourceSets {

			main {

				java.srcDirs += 'src/main/kotlin'

				// jniLibs.srcDirs = ['src/main/jniLibs']

				jniLibs.srcDirs = ['src/main/jniLibs']

			}

		}

    
4.  Add the following packages to your `pubspec.yaml` file:
    

    
	     whisper_dart:
	     file_picker: ^5.2.5
	     cool_alert: ^1.1.0
	     path_provider: ^2.0.13
    
5.  Download a preferred data set from [https://huggingface.co/datasets/ggerganov/whisper.cpp](https://huggingface.co/datasets/ggerganov/whisper.cpp) and place it in the assets folder of your project. Note that this will increase the size of your app, as the smallest data set is over 70MB. In this repository, the data set is not included due to GitHub's 50-file limit.
    
6.  If you do not want to use the data set from the assets folder, you can remove or delete the `loadModel()` function from the `initState`, download the data set to your device, and choose it by pressing `set model`. For more information, please refer to the provided video.
    
7.  For sample .wav files, you can use [https://github.com/ggerganov/whisper.cpp/blob/master/samples/jfk.wav](https://github.com/ggerganov/whisper.cpp/blob/master/samples/jfk.wav).
    

## Demo

To run the demo, simply copy and paste the `main.dart` file from this repository into your project. The `loadModel` function will load the data model set from the asset folder.

## Credits

This repository is based on the example folder from the [whisper_dart](https://github.com/azkadev/whisper_dart) package and the wisdom from [whisper_dart_my_first_test_v2](https://github.com/williamidt/whisper_dart_my_first_test_v2).


**In action**
![video](https://github.com/iamthejahid/transcript_whisper_flutter/blob/main/media/vid.mp4?raw=true)
