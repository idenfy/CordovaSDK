## Table of contents

- [Getting started](#getting-started)
  - [1. Obtaining an identification token](#1-obtaining-an-identification-token)
  - [2. Adding Idenfy Cordova SDK](#2-adding-idenfy-cordova-sdk)
    - [2.1 Availability information & new project setup](#21-availability-information--new-project-setup)
    - [2.2 Adding SDK dependency through cordova CLI](#22-adding-sdk-dependency-through-cordova-cli)
    - [2.3 Adding SDK dependency through npm](#23-adding-sdk-dependency-through-npm)
    - [2.4 Configure IOS project](#24-configure-ios-project)

* [Usage](#usage)
* [Callbacks](#callbacks)
* [Additional customization](#additional-customization)
* [SDK Integration tutorials](#sdk-integration-tutorials)

## Getting started

The **IdenfySdkPlugin** is an official Cordova plugin, which provides an easier integration of iDenfy KYC services.

### 1. Obtaining an identification token

The SDK requires an identification token for starting initialization. [Token generation guide](https://documentation.idenfy.com/API/GeneratingIdentificationToken)

### 2. Adding Idenfy Cordova SDK

#### 2.1 Availability information & new project setup

Minimum required versions by the platform:

**IOS - 13.00**

**Android - API 21**

If you are starting a new Cordova project you can follow [environment setup guide](https://cordova.apache.org/docs/en/latest/guide/cli/).
Once the setup completed successfully, you can initialize a new project with CLI:

```shell
$ cordova create hello com.example.hello HelloWorld
```

#### 2.2 Adding SDK dependency through cordova CLI

Navigate to the root directory of your Cordova project. The rest of this second section will assume you are in the root directory.

Copy **IdenfySdkPlugin folder** from this repository and add it to the root of your project.
Run the following command:

```shell
$ cordova plugin add IdenfySdkPlugin
```

If you need to remove the plugin, run the following command:

```shell
$ cordova plugin rm com.idenfy.idenfysdkcordovaplugin
```

#### 2.3 Configure IOS project

`NSCameraUsageDescription' must be provided in the application's 'Info.plist' file:

```xml
<key>NSCameraUsageDescription</key>
<string>Required for document and facial capture</string>
```

Also navigate to platforms/ios/Podfile file and add the following post_install script:

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      if target.name == "lottie-ios"
        config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
      end
    end
  end
end
```

Then ensure that you **have use_frameworks! linkage as STATIC**.

```ruby
platform :ios, '13.0'
target 'CordovaSDK' do
  use_frameworks! :linkage => :static
	project 'CordovaSDK.xcodeproj'
	pod 'iDenfySDK-Static/iDenfyLiveness-Static', '8.5.7'
end
```

The sample app uses the following Podfile structure:

```ruby
platform :ios, '13.0'
target 'CordovaSDK' do
  use_frameworks! :linkage => :static
	project 'CordovaSDK.xcodeproj'
	pod 'iDenfySDK-Static/iDenfyLiveness-Static', '8.5.7'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      if target.name == "lottie-ios"
        config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
      end
    end
  end
end
```

## Usage

After successful integration, you should be able to call IdenfySdkPlugin.startIdentification method.
You can run on IOS with:

```shell
$ cordova build ios
$ cordova run ios
```

If you face issues, try these commands:

```shell
$ cordova platform remove ios
$ cordova platform add ios
```

On Android you would run it like this:

```shell
$ cordova run android
```

If you face issues, try these commands:

```shell
$ cordova platform remove android
$ cordova platform add android
```

If the project is not successfully compiled or runtime issues occur, make sure you have followed the steps. For better understanding, you may check the sample app in this repository.

Once you have an [identification token](https://documentation.idenfy.com/API/GeneratingIdentificationToken), you can initialize the idenfy cordova plugin, by calling IdenfySdkPlugin.startIdentification with provided authToken:

```javascript
function presentIdenfySDK() {
  IdenfySdkPlugin.startIdentification(
    "AUTH_TOKEN",
    function (result) {
      alert(JSON.stringify(result));
    },
    function (err) {
      alert(JSON.stringify(err));
    }
  );
}
```

## Callbacks

Callback from the SDK can be retrieved from the success callback in the method startIdentification:

```javascript
IdenfySdkPlugin.startIdentification(
  ...function (result) {
    alert(JSON.stringify(result));
  }
);
```

The result will have the following JSON structure:

```javascript
{
    "autoIdentificationStatus": "APPROVED",
    "manualIdentificationStatus": "APPROVED"
}
```

Information about the IdenfyIdentificationResult **autoIdentificationStatus** statuses:

| Name         | Description                                                                                                                       |
| ------------ | --------------------------------------------------------------------------------------------------------------------------------- |
| `APPROVED`   | The user completed an identification flow and the identification status, provided by an automated platform, is APPROVED.          |
| `FAILED`     | The user completed an identification flow and the identification status, provided by an automated platform, is FAILED.            |
| `UNVERIFIED` | The user did not complete an identification flow and the identification status, provided by an automated platform, is UNVERIFIED. |

Information about the IdenfyIdentificationResult **manualIdentificationStatus** statuses:

| Name       | Description                                                                                                                                                                                                                                             |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `APPROVED` | The user completed an identification flow and was verified manually while waiting for the manual verification results in the iDenfy SDK. The identification status, provided by a manual review, is APPROVED.                                           |
| `FAILED`   | The user completed an identification flow and was verified manually while waiting for the manual verification results in the iDenfy SDK. The identification status, provided by a manual review, is FAILED.                                             |
| `WAITING`  | The user completed an identification flow and started waiting for the manual verification results in the iDenfy SDK. Then he/she decided to stop waiting and pressed a "BACK TO ACCOUNT" button. The manual identification review is **still ongoing**. |
| `INACTIVE` | The user was only verified by an automated platform, not by a manual reviewer. The identification performed by the user can still be verified by the manual review if your system uses the manual verification service.                                 |

\*Note
The manualIdentificationStatus status always returns INACTIVE status, unless your system implements manual identification callback, but does not create **a separate waiting screen** for indicating about the ongoing manual identity verification process.
For better customization we suggest using the immediate redirect feature. As a result, the user will not see an automatic identification status, provided by the iDenfy service. The SDK will be closed while showing loading indicators.

## Additional customization

Currently, this Cordova plugin does not provide customization options via Javascript code directly. For any additional SDK customization, you should edit the native code inside of the plugin.

**Android customization:**
Follow [Android native SDK](https://documentation.idenfy.com/mobile/Android/android-sdk#customizing-sdk-flow-optional) guide and edit **IdenfySdkPlugin.java**.

**IOS customization:**
Follow [IOS native SDK guide](https://documentation.idenfy.com/mobile/iOS/ios-sdk) and edit **IdenfySdkPlugin.swift**.
