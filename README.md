This repository contains the codebase for IoT based LED strip Flutter app.
There are three major folders in the root directory-

1. Flutter app:
	- This folder contains the source code of the flutter app. 
	- It contains the src folder and the pubspec.yaml file.

2. Embedded C code:
	- This folder contains the embedded C code that has to be run on Arduino IDE.

3. Django API:
	- This folder contains a Python(Django) REST API.
	- It is used for converting Image pixels into an array of its HEX colors.
	
Installation Guide

Flutter app-
1. Create a new flutter app on Android Studio/VS Code of your local machine.
2. Copy and replace the src folder and the pubspec.yaml file to install the required dependencies.

Embedded C code-
1. Open the code in Arduino IDE.
2. Install FastLED and ESP8266 on your Arduino IDE.
3. Change the Wifi username and password.

Django app-
1. Run the command- "pip install -r requirements.txt" to install the required dependencies.
2. Run the command- "python manage.py runserver" from the root directory to start the localhost.

