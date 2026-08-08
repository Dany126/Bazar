import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  io.Socket? _socket;

  void connect({
    required String baseUrl,
    required String authToken,
    required void Function(Map<String, dynamic> data) onNotification,
  }) {
    _socket = io.io(
      baseUrl,
      io.OptionBuilder().setTransports(['websocket']).setAuth({
        'token': authToken,
      }).build(),
    );

    _socket!.connect();
    _socket!.on(
      'notification',
      (data) => onNotification(Map<String, dynamic>.from(data)),
    );
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }
}
