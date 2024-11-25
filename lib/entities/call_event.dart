/// Object CallEvent.
class CallEvent {
  Event event;
  dynamic body;

  CallEvent(this.body, this.event);
  @override
  String toString() => 'CallEvent( body: $body, event: $event)';
}

enum Event {
  actionDidUpdateDevicePushTokenVoip,
  actionCallIncoming,
  actionCallStart,
  actionCallAccept,
  actionCallDecline,
  actionCallEnded,
  actionCallTimeout,
  actionCallCallback,
  actionCallToggleHold,
  actionCallToggleMute,
  actionCallToggleDmtf,
  actionCallToggleGroup,
  actionCallToggleAudioSession,
  actionCallCustom,
}

/// Using extension for backward compatibility Dart SDK 2.17.0 and lower
extension EventX on Event {
  String get name {
    switch (this) {
      case Event.actionDidUpdateDevicePushTokenVoip:
        return 'com.am.notification_calling.DID_UPDATE_DEVICE_PUSH_TOKEN_VOIP';
      case Event.actionCallIncoming:
        return 'com.am.notification_calling.ACTION_CALL_INCOMING';
      case Event.actionCallStart:
        return 'com.am.notification_calling.ACTION_CALL_START';
      case Event.actionCallAccept:
        return 'com.am.notification_calling.ACTION_CALL_ACCEPT';
      case Event.actionCallDecline:
        return 'com.am.notification_calling.ACTION_CALL_DECLINE';
      case Event.actionCallEnded:
        return 'com.am.notification_calling.ACTION_CALL_ENDED';
      case Event.actionCallTimeout:
        return 'com.am.notification_calling.ACTION_CALL_TIMEOUT';
      case Event.actionCallCallback:
        return 'com.am.notification_calling.ACTION_CALL_CALLBACK';
      case Event.actionCallToggleHold:
        return 'com.am.notification_calling.ACTION_CALL_TOGGLE_HOLD';
      case Event.actionCallToggleMute:
        return 'com.am.notification_calling.ACTION_CALL_TOGGLE_MUTE';
      case Event.actionCallToggleDmtf:
        return 'com.am.notification_calling.ACTION_CALL_TOGGLE_DMTF';
      case Event.actionCallToggleGroup:
        return 'com.am.notification_calling.ACTION_CALL_TOGGLE_GROUP';
      case Event.actionCallToggleAudioSession:
        return 'com.am.notification_calling.ACTION_CALL_TOGGLE_AUDIO_SESSION';
      case Event.actionCallCustom:
        return 'com.am.notification_calling.ACTION_CALL_CUSTOM';
    }
  }
}
