import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  io.Socket? _socket;

  void connect({
    required String baseUrl,
    required String authToken,
    required void Function(Map<String, dynamic> data) onNotification,
  }) {
    disconnect();

    _socket = io.io(
      baseUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': authToken})
          .enableAutoConnect()
          .build(),
    );

    _socket!.connect();

    _socket!.onConnect((_) {
      log('SOCKET CONNECTED');
    });

    _socket!.onDisconnect((_) {
      log('SOCKET DISCONNECTED');
    });

    _socket!.onConnectError((error) {
      log('SOCKET ERROR: $error');
    });

    _socket!.on('notification', (data) {
      log('SOCKET NOTIFICATION');

      if (data is Map) {
        onNotification(Map<String, dynamic>.from(data));
      }
    });
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }
}
