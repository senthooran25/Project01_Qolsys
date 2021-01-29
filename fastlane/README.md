fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
### apply_new_version
```
fastlane apply_new_version
```


----

## Android
### android closed_beta
```
fastlane android closed_beta
```
Deploy to closed beta track
### android distribute_to_firebase
```
fastlane android distribute_to_firebase
```
Distribute to firebase

----

## iOS
### ios closed_beta
```
fastlane ios closed_beta
```
Deploy to TestFlight
### ios distribute_to_firebase
```
fastlane ios distribute_to_firebase
```
Distribute to firebase

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
