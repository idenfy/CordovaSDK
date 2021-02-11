## Table of contents
- [Getting started](#getting-started)
    - [1. Obtaining an authentication token](#1-obtaining-an-authentication-token)
    - [2. Adding Idenfy Cordova SDK](#2-adding-idenfy-cordova-sdk)
        - [2.1 Availability information & new project setup](#21-availability-information--new-project-setup)
        - [2.2 Adding SDK dependency through cordova CLI](#22-adding-sdk-dependency-through-cordova-cli)
        - [2.3 Configure IOS project](#23-configure-ios-project)
*   [Usage](#usage)
*   [Callbacks](#callbacks)
*   [Additional customization](#additional-customization)
*   [SDK Integration tutorials](#sdk-integration-tutorials)


## Getting started

The **IdenfySdkPlugin** is an official Cordova plugin, which provides an easier integration of iDenfy KYC services.

### 1. Obtaining an authentication token

The SDK requires token for starting initialization. [Token generation guide](https://github.com/idenfy/Documentation/blob/master/pages/GeneratingIdentificationToken.md)
### 2. Adding Idenfy Cordova SDK
#### 2.1 Availability information & new project setup
Minimum required versions by the platform:

**IOS - 9.00**

**Android - API 19**

If you are starting a new Cordova project you can follow [environment setup guide](https://cordova.apache.org/docs/en/latest/guide/cli/).
Once the setup completed successfully, you can initialize a new project with CLI:

```shell
$ cordova create hello com.example.hello HelloWorld
```

#### 2.2 Adding SDK dependency through cordova CLI

Navigate to the root directory of your Cordova project. The rest of this second section will assume you are in the root directory. 

Add **IdenfySdkPlugin folder** to the root of the folder.
Run the following command:

```shell
$ cordova plugin add IdenfySdkPlugin
```

If you need to remove plugin, run the following command:
```shell
$ cordova plugin rm com.idenfy.idenfysdkcordovaplugin
```
#### 2.3 Configure IOS project

`NSCameraUsageDescription' must be provided in the application's 'Info.plist' file:
```xml
<key>NSCameraUsageDescription</key>
<string>Required for document and facial capture</string>
```

## Usage

After successful integration you should be able to call IdenfySdkPlugin.startIdentification method.

If project is not successfully compiled or runtime issues occurs, make sure you have followed the steps. For better understanding you may check at the sample app in this repository.

Once you have an [authentication token](https://github.com/idenfy/Documentation/blob/master/pages/GeneratingIdentificationToken.md), you can initialize the idenfy cordova plugin, by calling IdenfySdkPlugin.startIdentification with provided authToken:


```javascript
function presentIdenfySDK() {
    IdenfySdkPlugin.startIdentification(
        'AUTH_TOKEN',
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
````javascript
IdenfySdkPlugin.startIdentification(
        ...
        function(result) {
            alert(JSON.stringify(result));
        }
    );
````
Result will have a following JSON structure:

```javascript
{
    "autoIdentificationStatus": "APPROVED",
    "manualIdentificationStatus": "APPROVED"
}
```

Information about the IdenfyIdentificationResult **autoIdentificationStatus** statuses:

|Name            |Description
|-------------------|------------------------------------
|`APPROVED`   |The user completed an identification flow and the identification status, provided by an automated platform, is APPROVED.
|`FAILED`|The user completed an identification flow and the identification status, provided by an automated platform, is FAILED.
|`UNVERIFIED`   |The user did not complete an identification flow and the identification status, provided by an automated platform, is UNVERIFIED. 

Information about the IdenfyIdentificationResult **manualIdentificationStatus** statuses:

|Name            |Description
|-------------------|------------------------------------
|`APPROVED`   |The user completed an identification flow and was verified manually while waiting for the manual verification results in the iDenfy SDK. The identification status, provided by a manual review, is APPROVED.
|`FAILED`|The user completed an identification flow and was verified manually while waiting for the manual verification results in the iDenfy SDK. The identification status, provided by a manual review, is FAILED.
|`WAITING`|The user completed an identification flow and started waiting for the manual verification results in the iDenfy SDK. Then he/she decided to stop waiting and pressed a "BACK TO ACCOUNT" button. The manual identification review is **still ongoing**.
|`INACTIVE`   |The user was only verified by an automated platform, not by a manual reviewer. The identification performed by the user can still be verified by the manual review if your system uses the manual verification service.

*Note
The manualIdentificationStatus status always returns INACTIVE status, unless your system implements manual identification callback, but does not create **a separate waiting screen** for indicating about the ongoing manual identity verification process.
For better customization we suggest using the [immediate redirect feature ](#customizing-results-callbacks-v2-optional). As a result, the user will not see an automatic identification status, provided by iDenfy service. The SDK will be closed while showing loading indicators.

## Additional customization
Currently, this cordova plugin does not provide customization options via Javascript code directly. For any additional SDK customization you should edit native code inside of the plugin.

**Android customization:**
Follow [Android native SDK](https://github.com/idenfy/Documentation/blob/master/pages/ANDROID-SDK.md#customizing-sdk-v2-optional) guide and edit **IdenfySdkPlugin.java**.

**IOS customization:**
Follow [IOS native SDK guide](https://github.com/idenfy/Documentation/blob/master/pages/ios-sdk.md#customizing-sdk-v2-optional) and edit **IdenfySdkPlugin.swift**.

## SDK Integration tutorials
For more information visit [SDK integration tutorials](https://github.com/idenfy/Documentation/blob/master/pages/tutorials/mobile-sdk-tutorials.md).









