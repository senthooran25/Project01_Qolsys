# Running the app
Launch the app on an emulator through an IDE

Or use the terminal to launch the app with the following command

`flutter run`

To set to development environment include runtime flags

`--dart-define=ENVIRONMENT_CONFIG=DEV` `--dart-define=IQCONTROL_BASE_URL=https://dev-api.qolsys.com/apps/v1/`

# Code generation
Use the following command to generate new translations

`flutter pub run easy_localization:generate -S assets/translations`

Use the following command to generate the keys file

`flutter pub run easy_localization:generate -S assets/translations -f keys -o locale_keys.g.dart`

command to generate part files

`flutter pub run build_runner build --delete-conflicting-outputs`

# Unit tests
Command to run unit tests

`flutter test`

# Integration tests

Required environment variables for integration tests:

`username=YOURTESTUSERNAME`

`password=YOURTESTPASSWORD`

Command to run integration tests

`flutter drive --target=test_driver/app.dart`

Including setting environment to development

`flutter drive --target=test_driver/app.dart --dart-define=IQCONTROL_BASE_URL=https://dev-api.qolsys.com/apps/v1/ --dart-define=ENVIRONMENT_CONFIG=DEV`

# UI mockups
    
   https://www.figma.com/proto/6zueSA0UCBg7QAOKlAjWgw/Qolsys-App-UI?node-id=3273%3A0&scaling=scale-down

## Deploy Android APP 

- Install dependencies
    -   gem install bundler:1.17.2
    -   bundle install
    -   flutter pub get
    -   export ANDROID_KEYS_SECRET_PASSPHRASE=\<****PASSPHRASE***\>
    -   . ./.github/scripts/decrypt_android_secrets.sh 
* get **PASSPHRASE** code
### Deploy Android production APP to Play Store

    -   bundle exec fastlane apply_new_version
    -   flutter build appbundle  --release --obfuscate --split-debug-info=build/app/outputs/symbols
    -   bundle exec fastlane android closed_beta
    
### Deploy Android development APP to Firebase


    -   bundle exec fastlane apply_new_version
    -   flutter build apk --dart-define=ENVIRONMENT_CONFIG=DEV --dart-define=IQCONTROL_BASE_URL=https://dev-api.qolsys.com/apps/v1/ --debug
    -   bundle exec fastlane android distribute_to_firebase

## Deploy iOS APP


Set environment variables in fastlane/**.env.default**

- Sync development certificates:
    -   fastlane match development --readonly
    -   fastlane match appstore --readonly
    -   fastlane match adhoc --readonly


- Install dependencies
    -   gem install bundler:1.17.2
    -   bundle install
    -   flutter pub get


### Deploy iOS  development APP to Firebase

    -   bundle exec fastlane apply_new_version
    -   flutter build ios --dart-define=ENVIRONMENT_CONFIG=DEV --dart-define=IQCONTROL_BASE_URL=https://dev-api.qolsys.com/apps/v1/ --debug --no-codesign
    -   bundle exec fastlane ios distribute_to_firebase

### Deploy iOS  production APP to Testflight

    -   bundle exec fastlane apply_new_version
    -   flutter build ios --release --no-codesign --obfuscate --split-debug-info=build/ios/symbols
    -   bundle exec fastlane ios closed_beta

##  APP version

flutter_version_manager plugin manages app versioning of Flutter project.
This plugin heavily resides on having a git repository and at least one commit as version code is applied through timestamp of HEAD commit. As for app version, `version.yml` should be used as a single source of truth.
https://github.com/rubiconba/fastlane-plugin-flutter-version-manager

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
