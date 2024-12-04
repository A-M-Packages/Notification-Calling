// lib/screens/caller_video_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:avatar_glow/avatar_glow.dart';

import '../services/socket_service.dart';
import '../services/webrtc_service.dart';

class CallerVideoScreen extends StatefulWidget {
  final String callerId, receiverId, callId, receiverName;

  const CallerVideoScreen({
    Key? key,
    required this.callerId,
    required this.receiverId,
    required this.callId,
    required this.receiverName,
  }) : super(key: key);

  @override
  State<CallerVideoScreen> createState() => _CallerVideoScreenState();
}

class _CallerVideoScreenState extends State<CallerVideoScreen> {
  late WebrtcService webrtcService;
  late SocketService socketService;
  late int _callDuration;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    // تهيئة SocketService مع baseUrl و userId
    socketService = SocketService(
      serverBaseUrl:
          '', // تأكد من تعريف EndPoints.baseUrl في ملف end_points.dart
      userId: '',
    );
    socketService.initializeSocket();

    // تهيئة WebrtcService وتمرير SocketService و callId
    webrtcService = WebrtcService(
      socketService: socketService,
      callId: widget.callId,
    );

    // بدء تهيئة Renderers و الاتصال
    webrtcService.initializeRenderers().then((_) {
      webrtcService.initializeCall();
      webrtcService.initializeCallListeners();
    });

    // بدء العداد الزمني للمكالمة
    _startTimer();

    // الاستماع لرسالة 'callEnded' من السيرفر
    socketService.onMessage('callEnded', (data) {
      _stopTimer();
      Navigator.pop(context);
    });

    // تفعيل الواكلوك لمنع إيقاف الشاشة أثناء المكالمة
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    // إيقاف الواكلوك
    WakelockPlus.disable();

    // إنهاء المكالمة وتنظيف الموارد
    webrtcService.leaveCall();

    // إيقاف العداد الزمني
    _stopTimer();

    // إغلاق الاتصال بالـ Socket
    socketService.disconnect();

    super.dispose();
  }

  /// دالة لتنسيق الوقت
  String _formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  /// بدء العداد الزمني للمكالمة
  void _startTimer() {
    _callDuration = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _callDuration++;
      });
    });
  }

  /// إيقاف العداد الزمني للمكالمة
  void _stopTimer() {
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  RTCVideoView(
                    webrtcService.remoteRenderer,
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    placeholderBuilder: (context) {
                      return Container(
                        color: Colors.grey.shade300,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AvatarGlow(
                              animate: true,
                              glowRadiusFactor: 0.5,
                              child: Material(
                                shape: const CircleBorder(),
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey[100],
                                  backgroundImage: const AssetImage(
                                      "assets/images/avatar.png"),
                                  radius: 100,
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: 20,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Text(
                            _formatDuration(_callDuration),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          const ImageIcon(
                            AssetImage("assets/icons/network.png"),
                            color: Colors.blue,
                            size: 17,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Text(
                            widget.receiverName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          const ImageIcon(
                            AssetImage("assets/icons/caller_name.png"),
                            color: Colors.blueGrey,
                            size: 17,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 20,
                    bottom: 150,
                    child: SizedBox(
                      height: 224.h,
                      width: 150.w,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: RTCVideoView(
                          webrtcService.localRenderer,
                          mirror: webrtcService.isFrontCameraSelected,
                          objectFit:
                              RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // زر إغلاق المكالمة
                          IconButton(
                            onPressed: () {
                              webrtcService.leaveCall();
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 30,
                            ),
                            style: const ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.red),
                              fixedSize: WidgetStatePropertyAll(Size(60, 60)),
                            ),
                          ),
                          // زر تبديل الميكروفون
                          IconButton(
                            onPressed: () {
                              setState(() {
                                webrtcService.toggleAudio();
                              });
                            },
                            icon: Icon(
                              webrtcService.isAudioOn
                                  ? Icons.mic
                                  : Icons.mic_off,
                              color: Colors.white,
                              size: 30,
                            ),
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                webrtcService.isAudioOn
                                    ? Colors.grey.shade500
                                    : Colors.blueGrey,
                              ),
                            ),
                          ),
                          // زر تبديل الكاميرا
                          IconButton(
                            onPressed: () {
                              setState(() {
                                webrtcService.switchCamera();
                              });
                            },
                            icon: Icon(
                              webrtcService.isFrontCameraSelected
                                  ? Icons.cameraswitch
                                  : Icons.cameraswitch_outlined,
                              color: Colors.white,
                              size: 30,
                            ),
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                webrtcService.isFrontCameraSelected
                                    ? Colors.grey.shade500
                                    : Colors.blueGrey,
                              ),
                            ),
                          ),
                          // زر تبديل الفيديو
                          IconButton(
                            onPressed: () {
                              setState(() {
                                webrtcService.toggleVideo();
                              });
                            },
                            icon: Icon(
                              webrtcService.isVideoOn
                                  ? Icons.videocam
                                  : Icons.videocam_off,
                              color: Colors.white,
                              size: 30,
                            ),
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                webrtcService.isVideoOn
                                    ? Colors.grey.shade500
                                    : Colors.blueGrey,
                              ),
                            ),
                          ),
                          // زر تبديل مكبر الصوت
                          IconButton(
                            onPressed: () {
                              setState(() {
                                webrtcService.toggleSpeaker();
                              });
                            },
                            icon: Icon(
                              webrtcService.isSpeakerOn
                                  ? Icons.volume_up
                                  : Icons.volume_off,
                              color: Colors.white,
                              size: 30,
                            ),
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                webrtcService.isSpeakerOn
                                    ? Colors.blueGrey
                                    : Colors.grey.shade500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
