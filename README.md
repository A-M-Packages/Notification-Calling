# Notification Calling

A Flutter plugin to show incoming call in your Flutter app(Custom for Android/Callkit for iOS).

[//]: # ([![pub package]&#40;https://img.shields.io/pub/v/flutter_callkit_incoming.svg&#41;]&#40;https://pub.dev/packages/flutter_callkit_incoming&#41;)

[//]: # ([![pub points]&#40;https://img.shields.io/pub/points/flutter_callkit_incoming?label=pub%20points&#41;]&#40;https://pub.dev/packages/flutter_callkit_incoming/score&#41;)

[//]: # ([![GitHub stars]&#40;https://img.shields.io/github/stars/hiennguyen92/flutter_callkit_incoming.svg?style=social&#41;]&#40;https://github.com/A-M-Packages/Notification-Calling/stargazers&#41;)

[//]: # ([![GitHub forks]&#40;https://img.shields.io/github/forks/hiennguyen92/flutter_callkit_incoming.svg?style=social&#41;]&#40;https://github.com/A-M-Packages/Notification-Calling/network&#41;)

[//]: # ([![GitHub license]&#40;https://img.shields.io/github/license/hiennguyen92/flutter_callkit_incoming.svg&#41;]&#40;https://github.com/A-M-Packages/Notification-Calling/blob/master/LICENSE&#41;)

## :star: Features

* Show an incoming call


  <br>

## iOS: ONLY WORKING ON REAL DEVICE, not on simulator(Callkit framework not working on simulator)

<br>

## 🚀&nbsp; Installation

1. Install Packages

  * Run this command:
    ```console
    flutter pub add notification_calling
    ```
    * Add pubspec.yaml:
      ```console
          dependencies:
            notification_calling: any
      ```
      2. Configure Project
         * Android
            * AndroidManifest.xml
            ```
             <manifest...>
                 ...
                 <!--
                     Using for load image from internet
                 -->
                 <uses-permission android:name="android.permission.INTERNET"/>

               <application ...>
                   <activity ...
                      android:name=".MainActivity"
                      android:launchMode="singleInstance">
                    ...
               ...
    
             </manifest>
            ```
            The following rule needs to be added in the proguard-rules.pro to avoid obfuscated keys.
            ```
             -keep class com.am.notification_calling.** { *; }
            ```
  * iOS
     * Info.plist
      ```
      <key>UIBackgroundModes</key>
      <array>
          <string>voip</string>
          <string>remote-notification</string>
          <string>processing</string> //you can add this if needed
      </array>
      ```

3. Usage
  * Import
    ```console
    import 'package:notification_calling/flutter_callkit_incoming.dart';
    ```
  * Received an incoming call
    ```dart
      CallKitParams params = CallKitParams(
      id: notificationData['callId'],
      nameCaller: notificationData['callerName'],
      appName: "app name",
      // avatar: 'ic_default_avatar.png',
      avatar: 'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgPTs9UbgJg34C5wSSFIgtJwpOJENS6D0lcBkBNhmBzIn_4OWsVNfyHCFRwEcgcKwid1L8u-6n3TRRbHWkvtLxjdN7ylmMCiCN7sXGgQdT_pJKARsZw2XCd4BjEgTBXvFhYVGBBYR1B9jqmgW9upqNbh_82pb-jTjjWGtfJKaCGhIRn2Tq4FMsUwi2IZbZj/s512/user.png',
      handle: 'inComing call',
      type: notificationData['callType'] == 'voice' ? 0 : 1,
      duration: 30000,
      textAccept: 'Accept',
      textDecline: 'Decline',
      missedCallNotification: const NotificationParams(
        showNotification: true,
        isShowCallback: false,
        subtitle: 'Missed call',
        // callbackText: 'Call back',
      ),
      extra: notificationData,

      headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
      android: const AndroidParams(
        isCustomNotification: true,
        isShowLogo: true,
        incomingCallNotificationChannelName: "Incoming Call",
        isCustomSmallExNotification: true,
        isShowFullLockedScreen: true,
        ringtonePath: 'incoming_call',
        // backgroundColor: '#0955fa',
        backgroundUrl: 'assets/images/call_background.jpg',
        actionColor: '#4CAF50',
        textColor: '#ffffff',
      ),
      ios: const IOSParams(
        iconName: 'app name',

        // handleType: '',
        supportsVideo: true,
        maximumCallGroups: 2,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'incoming_call',
      ),
    );
    await FlutterCallkitIncoming.showCallkitIncoming(params);
    ```
    Note: Firebase Message: `@pragma('vm:entry-point')` <br/>
    https://github.com/firebase/flutterfire/blob/master/docs/cloud-messaging/receive.md#apple-platforms-and-android

  * request permission for post Notification Android 13+
  For Android 13+, please `requestNotificationPermission` or requestPermission of firebase_messaging before `showCallkitIncoming`
    ```dart
      await FlutterCallkitIncoming.requestNotificationPermission({
        "rationaleMessagePermission": "Notification permission is required, to show notification.",
        "postNotificationMessageRequired": "Notification permission is required, Please allow notification permission from setting."
      });
    ```

  * request permission for full intent Notification/full screen locked screen Android 14+
  For Android 14+, please `requestFullIntentPermission`
    ```dart
      await FlutterCallkitIncoming.requestFullIntentPermission();
    ```

  * Show miss call notification
    ```dart
      
      CallKitParams params = CallKitParams(
        id: notificationData['callId'],
        nameCaller: notificationData['callerName'],
        handle: '0123456789',
        type: 1,
        textMissedCall: 'Missed call',
        textCallback: 'Call back',
        extra: <String, dynamic>{'userId': '1a2b3c4d'},
      );
      await FlutterCallkitIncoming.showMissCallNotification(params);
    ```
  * Hide notification call for Android
    ```
      CallKitParams params = CallKitParams(
        id: _currentUuid,
      );
     await FlutterCallkitIncoming.hideCallkitIncoming(params);
    ```

  * Started an outgoing call
    ```dart
     
      CallKitParams params = CallKitParams(
        id: notificationData['callId'],
        nameCaller: notificationData['callerName'],
        handle: '0123456789',
        type: 1,
        extra: <String, dynamic>{'userId': '1a2b3c4d'},
        ios: IOSParams(handleType: 'generic')
      );
      await FlutterCallkitIncoming.startCall(params);
    ```

  * Ended an incoming/outgoing call
    ```dart
      await FlutterCallkitIncoming.endCall(notificationData['callId']);
    ```

  * Ended all calls
    ```dart
      await FlutterCallkitIncoming.endAllCalls();
    ```

  * Get active calls. iOS: return active calls from Callkit(only id), Android: only return last call
    ```dart
      await FlutterCallkitIncoming.activeCalls();
    ```
    Output
    ```json
    [{"id": "8BAA2B26-47AD-42C1-9197-1D75F662DF78", ...}]
    ```
  * Set status call connected (only for iOS - used to determine Incoming Call or Outgoing Call status in phone book)
    ```
      await FlutterCallkitIncoming.setCallConnected(this._currentUuid);
    ```
    After the call is ACCEPT or startCall please call this func.
    normally it should be called when webrtc/p2p.... is established.

  * Get device push token VoIP. iOS: return deviceToken, Android: Empty

    ```dart
      await FlutterCallkitIncoming.getDevicePushTokenVoIP();
    ```
    Output

    ```json
    <device token>

    //Example
   d6a77ca80c5f09f87f353cdd328ec8d7d34e92eb108d046c91906f27f54949cd

    ```
    Make sure using `SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP(deviceToken)` inside AppDelegate.swift (<a href="https://github.com/A-M-Packages/Notification-Calling/blob/master/example/ios/Runner/AppDelegate.swift">Example</a>)
    ```swift
    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        print(credentials.token)
        let deviceToken = credentials.token.map { String(format: "%02x", $0) }.joined()
        //Save deviceToken to your server
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP(deviceToken)
    }

    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        print("didInvalidatePushTokenFor")
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP("")
    }
    ```


  * Listen events ( work only in Foreground & Background  Mode)
    ```dart
      FlutterCallkitIncoming.onEvent.listen((CallEvent event) {
        switch (event!.event) {
          case Event.actionCallIncoming:
            // TODO: received an incoming call
            break;
          case Event.actionCallStart:
            // TODO: started an outgoing call
            // TODO: show screen calling in Flutter
            break;
          case Event.actionCallAccept:
            // TODO: accepted an incoming call
            // TODO: show screen calling in Flutter
            break;
          case Event.actionCallDecline:
            // TODO: declined an incoming call
            break;
          case Event.actionCallEnded:
            // TODO: ended an incoming/outgoing call
            break;
          case Event.actionCallTimeout:
            // TODO: missed an incoming call
            break;
          case Event.actionCallCallback:
            // TODO: only Android - click action `Call back` from missed call notification
            break;
          case Event.actionCallToggleHold:
            // TODO: only iOS
            break;
          case Event.actionCallToggleMute:
            // TODO: only iOS
            break;
          case Event.actionCallToggleDmtf:
            // TODO: only iOS
            break;
          case Event.actionCallToggleGroup:
            // TODO: only iOS
            break;
          case Event.actionCallToggleAudioSession:
            // TODO: only iOS
            break;
          case Event.actionDidUpdateDevicePushTokenVoip:
            // TODO: only iOS
            break;
          case Event.actionCallCustom:
            // TODO: for custom action
            break;
        }
      });
    ```
  * Call from Native (iOS/Android)

    ```swift
      //Swift iOS
      var info = [String: Any?]()
      info["id"] = "44d915e1-5ff4-4bed-bf13-c423048ec97a"
      info["nameCaller"] = "Hien Nguyen"
      info["handle"] = "0123456789"
      info["type"] = 1
      //... set more data
      SwiftFlutterCallkitIncomingPlugin.sharedInstance?.showCallkitIncoming(flutter_callkit_incoming.Data(args: info), fromPushKit: true)

      //please make sure call `completion()` at the end of the pushRegistry(......, completion: @escaping () -> Void)
      // or `DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { completion() }`
      // if you don't call completion() in pushRegistry(......, completion: @escaping () -> Void), there may be app crash by system when receiving voIP
    ```

    ```kotlin
        //Kotlin/Java Android
        FlutterCallkitIncomingPlugin.getInstance().showIncomingNotification(...)
    ```

    <br>

    ```swift
      //OR
      let data = flutter_callkit_incoming.Data(id: "44d915e1-5ff4-4bed-bf13-c423048ec97a", nameCaller: "Hien Nguyen", handle: "0123456789", type: 0)
      data.nameCaller = "Johnny"
      data.extra = ["user": "abc@123", "platform": "ios"]
      //... set more data
      SwiftFlutterCallkitIncomingPlugin.sharedInstance?.showCallkitIncoming(data, fromPushKit: true)
    ```

    <br>

    ```objc
      //Objective-C
      #if __has_include(<flutter_callkit_incoming/flutter_callkit_incoming-Swift.h>)
      #import <flutter_callkit_incoming/flutter_callkit_incoming-Swift.h>
      #else
      #import "flutter_callkit_incoming-Swift.h"
      #endif

      Data * data = [[Data alloc]initWithId:@"44d915e1-5ff4-4bed-bf13-c423048ec97a" nameCaller:@"Hien Nguyen" handle:@"0123456789" type:1];
      [data setNameCaller:@"Johnny"];
      [data setExtra:@{ @"userId" : @"HelloXXXX", @"key2" : @"value2"}];
      //... set more data
      [SwiftFlutterCallkitIncomingPlugin.sharedInstance showCallkitIncoming:data fromPushKit:YES];
    ```

    <br>

    ```swift
      //send custom event from native
      SwiftFlutterCallkitIncomingPlugin.sharedInstance?.sendEventCustom(body: ["customKey": "customValue"])

    ```

    ```kotlin
        //Kotlin/Java Android
        FlutterCallkitIncomingPlugin.getInstance().sendEventCustom(body: Map<String, Any>)
    ```
    * 3.1 Call API when accept/decline/end/timeout
    ```swift
    //Appdelegate
    ...
    @UIApplicationMain
    @objc class AppDelegate: FlutterAppDelegate, PKPushRegistryDelegate, CallkitIncomingAppDelegate {
    ...

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        //Setup VOIP
        let mainQueue = DispatchQueue.main
        let voipRegistry: PKPushRegistry = PKPushRegistry(queue: mainQueue)
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [PKPushType.voIP]

        //Use if using WebRTC
        //RTCAudioSession.sharedInstance().useManualAudio = true
        //RTCAudioSession.sharedInstance().isAudioEnabled = false
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }


    // Func Call api for Accept
    func onAccept(_ call: Call, _ action: CXAnswerCallAction) {
        let json = ["action": "ACCEPT", "data": call.data.toJSON()] as [String: Any]
        print("LOG: onAccept")
        self.performRequest(parameters: json) { result in
            switch result {
            case .success(let data):
                print("Received data: \(data)")
                //Make sure call action.fulfill() when you are done(connected WebRTC - Start counting seconds)
                action.fulfill()

            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    // Func Call API for Decline
    func onDecline(_ call: Call, _ action: CXEndCallAction) {
        let json = ["action": "DECLINE", "data": call.data.toJSON()] as [String: Any]
        print("LOG: onDecline")
        self.performRequest(parameters: json) { result in
            switch result {
            case .success(let data):
                print("Received data: \(data)")
                //Make sure call action.fulfill() when you are done
                action.fulfill()

            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    // Func Call API for End
    func onEnd(_ call: Call, _ action: CXEndCallAction) {
        let json = ["action": "END", "data": call.data.toJSON()] as [String: Any]
        print("LOG: onEnd")
        self.performRequest(parameters: json) { result in
            switch result {
            case .success(let data):
                print("Received data: \(data)")
                //Make sure call action.fulfill() when you are done
                action.fulfill()

            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func onTimeOut(_ call: Call) {
        let json = ["action": "TIMEOUT", "data": call.data.toJSON()] as [String: Any]
        print("LOG: onTimeOut")
        self.performRequest(parameters: json) { result in
            switch result {
            case .success(let data):
                print("Received data: \(data)")

            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func didActivateAudioSession(_ audioSession: AVAudioSession) {
        //Use if using WebRTC
        //RTCAudioSession.sharedInstance().audioSessionDidActivate(audioSession)
        //RTCAudioSession.sharedInstance().isAudioEnabled = true
    }
    
    func didDeactivateAudioSession(_ audioSession: AVAudioSession) {
        //Use if using WebRTC
        //RTCAudioSession.sharedInstance().audioSessionDidDeactivate(audioSession)
        //RTCAudioSession.sharedInstance().isAudioEnabled = false
    }
    ...

    ``` 
    <a href='https://github.com/A-M-Packages/Notification-Calling/blob/master/example/ios/Runner/AppDelegate.swift'>Please check full: Example</a>

4. Properties

    | Prop            | Description                                                             | Default     |
    | --------------- | ----------------------------------------------------------------------- | ----------- |
    |  **`id`**       | UUID identifier for each call. UUID should be unique for every call and when the call is  ended, the same UUID for that call to be used. suggest using <a href='https://pub.dev/packages/uuid'>uuid.</a> ACCEPT ONLY UUID    | Required    |
    | **`nameCaller`**| Caller's name.                                                          | _None_      |
    | **`appName`**   | App's name. using for display inside Callkit(iOS).                      |   App Name, `Deprecated for iOS > 14, default using App name`  |
    | **`avatar`**    | Avatar's URL used for display for Android. `/android/src/main/res/drawable-xxxhdpi/ic_default_avatar.png`                             |    _None_   |
    | **`handle`**    | Phone number/Email/Any.                                                 |    _None_   |
    |   **`type`**    |  0 - Audio Call, 1 - Video Call                                         |     `0`     |
    | **`duration`**  | Incoming call/Outgoing call display time (second). If the time is over, the call will be missed.                                                                                     |    `30000`  |
   | **`textAccept`**  | Text `Accept` used in Android                                            |    `Accept`  |
   | **`textDecline`**  | Text `Decline` used in Android                                           |    `Decline`  |
    |   **`extra`**   | Any data added to the event when received.                              |     `{}`    |
    |   **`headers`** | Any data for custom header avatar/background image.                     |     `{}`    |
    |  **`missedCallNotification`**  | Android data needed to customize Miss Call Notification.                                    |    Below    |
    |  **`android`**  | Android data needed to customize UI.                                    |    Below    |
    |    **`ios`**    | iOS data needed.                                                        |    Below    |

    <br>

* Missed Call Notification

    | Prop            | Description                                                             | Default     |
    | --------------- | ----------------------------------------------------------------------- | ----------- |
    | **`subtitle`**  | Text `Missed Call` used in Android (show in miss call notification)  |    `Missed Call`  |
   | **`callbackText`**  | Text `Call back` used in Android (show in miss call notification)     |    `Call back`  |
   |       **`showNotification`**      | Show missed call notification when timeout | `true`          |
    |       **`isShowCallback`**      | Show callback action from miss call notification. | `true`          |
* Android

    | Prop                        | Description                                                                                          | Default                                                           |
    | --------------------------- |------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------|
    | **`isCustomNotification`**  | Using custom notifications.                                                                          | `false`                                                           |
    | **`isCustomSmallExNotification`**  | Using custom notification small on some devices clipped out in android.                              | `false`                                                           |
    |       **`isShowLogo`**      | Show logo app inside full screen. `/android/src/main/res/drawable-xxxhdpi/ic_logo.png`               | `false`                                                           |
    |      **`ringtonePath`**     | File name ringtone. put file into `/android/app/src/main/res/raw/ringtone_default.pm3`               | `system_ringtone_default` <br>using ringtone default of the phone |
    |     **`backgroundColor`**   | Incoming call screen background color.                                                               | `#0955fa`                                                         |
    |      **`backgroundUrl`**    | Using image background for Incoming call screen. example: http://... https://... or "assets/abc.png" | _None_                                                            |
    |      **`actionColor`**      | Color used in button/text on notification.                                                           | `#4CAF50`                                                         |
    |      **`textColor`**      | Color used for the text in full screen notification.                                                 | `#ffffff`                                                         |
    |  **`incomingCallNotificationChannelName`** | Notification channel name of incoming call.                                                          | `Incoming call`                                                   |
    |  **`missedCallNotificationChannelName`** | Notification channel name of missed call.                                                            | `Missed call`                                                     |
    |  **`isShowCallID`** | Show call id app inside full screen/notification.                                                    | false                                                             |
    |  **`isShowFullLockedScreen`** | Show full screen on Locked Screen(please make sure call `requestFullIntentPermission` for android 14+).                                                                   | true                                                              |

    <br>

* iOS

    | Prop                                      | Description                                                             | Default     |
    | ----------------------------------------- | ----------------------------------------------------------------------- | ----------- |
    |               **`iconName`**              | App's Icon. using for display inside Callkit(iOS)                       | `CallKitLogo` <br> using from `Images.xcassets/CallKitLogo`    |
    |              **`handleType`**             | Type handle call `generic`, `number`, `email`                           | `generic`   |
    |             **`supportsVideo`**           |                                                                         |   `true`    |
    |          **`maximumCallGroups`**          |                                                                         |     `2`     |
    |       **`maximumCallsPerCallGroup`**      |                                                                         |     `1`     |
    |           **`audioSessionMode`**          |                                                                         |   _None_, `gameChat`, `measurement`, `moviePlayback`, `spokenAudio`, `videoChat`, `videoRecording`, `voiceChat`, `voicePrompt`  |
    |        **`audioSessionActive`**           |                                                                         |    `true`   |
    |   **`audioSessionPreferredSampleRate`**   |                                                                         |  `44100.0`  |
    |**`audioSessionPreferredIOBufferDuration`**|                                                                         |  `0.005`    |
    |            **`supportsDTMF`**             |                                                                         |    `true`   |
    |            **`supportsHolding`**          |                                                                         |    `true`   |
    |          **`supportsGrouping`**           |                                                                         |    `true`   |
    |         **`supportsUngrouping`**          |                                                                         |   `true`    |
    |           **`ringtonePath`**              | Add file to root project xcode  `/ios/Runner/Ringtone.caf`  and Copy Bundle Resources(Build Phases)                                                                                                               |`Ringtone.caf`<br>`system_ringtone_default` <br>using ringtone default of the phone|



5. Pushkit - Received VoIP and Wake app from Terminated State (only for IOS)
  * Please check <a href="https://github.com/A-M-Packages/Notification-Calling/blob/master/PUSHKIT.md">PUSHKIT.md</a> setup Pushkit for IOS

  <br>
