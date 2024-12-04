// lib/services/socket_service.dart

import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;
  late String serverBaseUrl;
  late String userId;

  /// Constructor with baseUrl and userId
  SocketService({required this.serverBaseUrl, required this.userId}) {
    initializeSocket();
  }

  /// Initialize the socket connection
  void initializeSocket() {
    socket = IO.io(serverBaseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.connect();

    socket.on('connect', (_) {
      debugPrint('Connected to the server at $serverBaseUrl');
      debugPrint('User ID: $userId');
      socket.emit('join', {'userId': userId});
    });

    socket.on('disconnect', (_) {
      debugPrint('Disconnected from the server');
    });

    socket.on('error', (data) {
      debugPrint('Socket error: $data');
    });
  }

  /// Emit message to server
  void emitMessage(String event, dynamic data) {
    socket.emit(event, data);
  }

  /// Listen for messages from server
  void onMessage(String event, Function(dynamic) callback) {
    socket.on(event, callback);
  }

  /// Remove listener for event
  void off(String event) {
    socket.off(event);
  }

  /// Disconnect the socket
  void disconnect() {
    socket.disconnect();
  }
}
