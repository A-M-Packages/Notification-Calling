// lib/services/webrtc_service.dart

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_audio_manager_plus/flutter_audio_manager_plus.dart';
import 'package:notification_calling/services/socket_service.dart';

class WebrtcService {
  late RTCPeerConnection _peerConnection;
  late RTCVideoRenderer _localRenderer;
  late RTCVideoRenderer _remoteRenderer;
  final SocketService socketService;
  final String callId;

  bool isAudioOn = true;
  bool isVideoOn = true;
  bool isFrontCameraSelected = true;
  bool isRemoteVideoOn = true;
  bool isSpeakerOn = false;

  WebrtcService({
    required this.socketService,
    required this.callId,
  });

  /// تهيئة الـ Renderers
  Future<void> initializeRenderers() async {
    _localRenderer = RTCVideoRenderer();
    _remoteRenderer = RTCVideoRenderer();
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  /// تهيئة الاتصال عبر WebRTC
  Future<void> initializeCall() async {
    _peerConnection = await createPeerConnection({
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ]
    });

    _peerConnection.onIceCandidate = (RTCIceCandidate candidate) {
      socketService.emitMessage('ice-candidate', {
        'callId': callId,
        'candidate': candidate.toMap(),
      });
    };

    _peerConnection.onTrack = (RTCTrackEvent event) {
      if (event.track.kind == 'video') {
        _remoteRenderer.srcObject = event.streams[0];
        isRemoteVideoOn = true;
      }
    };

    // الحصول على الـ Media Streams المحلي
    var localStream = await navigator.mediaDevices.getUserMedia({
      'video': true,
      'audio': true,
    });

    localStream.getTracks().forEach((track) {
      _peerConnection.addTrack(track, localStream);
    });

    _localRenderer.srcObject = localStream;

    // إنشاء Offer وإرساله إلى السيرفر
    var offer = await _peerConnection.createOffer();
    await _peerConnection.setLocalDescription(offer);

    socketService.emitMessage('make-offer', {
      'callId': callId,
      'offer': offer.toMap(),
    });
  }

  /// الاستماع لرسائل الـ Call
  void initializeCallListeners() {
    socketService.onMessage('answer', (data) async {
      var answer =
          RTCSessionDescription(data['answer']['sdp'], data['answer']['type']);
      await _peerConnection.setRemoteDescription(answer);
    });

    socketService.onMessage('iceCandidate', (data) async {
      var candidate = RTCIceCandidate(
        data['candidate']['candidate'],
        data['candidate']['sdpMid'],
        data['candidate']['sdpMLineIndex'],
      );
      await _peerConnection.addCandidate(candidate);
    });
  }

  /// إيقاف المكالمة وتنظيف الموارد
  void leaveCall() async {
    await _peerConnection.close();
    _cleanupRenderers();
    socketService.emitMessage('end-call', {
      "callId": callId,
    });
  }

  /// تنظيف الـ Renderers
  void _cleanupRenderers() {
    _localRenderer.srcObject?.getTracks().forEach((track) {
      track.stop();
    });
    _localRenderer.srcObject = null;
    _localRenderer.dispose();

    _remoteRenderer.srcObject?.getTracks().forEach((track) {
      track.stop();
    });
    _remoteRenderer.srcObject = null;
    _remoteRenderer.dispose();
  }

  /// تبديل حالة الميكروفون
  void toggleAudio() {
    isAudioOn = !isAudioOn;
    _localRenderer.srcObject?.getAudioTracks().forEach((track) {
      track.enabled = isAudioOn;
    });
  }

  /// تبديل حالة الفيديو
  void toggleVideo() {
    isVideoOn = !isVideoOn;
    _localRenderer.srcObject?.getVideoTracks().forEach((track) {
      track.enabled = isVideoOn;
    });
  }

  /// تبديل الكاميرا بين الأمامية والخلفية
  void switchCamera() {
    isFrontCameraSelected = !isFrontCameraSelected;
    _localRenderer.srcObject?.getVideoTracks().forEach((track) {
      // ignore: deprecated_member_use
      track.switchCamera();
    });
  }

  /// تبديل مكبر الصوت
  Future<void> toggleSpeaker() async {
    isSpeakerOn = !isSpeakerOn;
    try {
      if (isSpeakerOn) {
        await FlutterAudioManagerPlus.changeToSpeaker();
      } else {
        await FlutterAudioManagerPlus.changeToReceiver();
      }
    } catch (e) {
      debugPrint("toggleSpeaker error: $e");
    }
  }

  RTCVideoRenderer get localRenderer => _localRenderer;
  RTCVideoRenderer get remoteRenderer => _remoteRenderer;
}
