import 'package:socket_io_client/socket_io_client.dart' as IO;

final String baseSocketServerUrl = 'https://jangle-api.herokuapp.com/';
// final String baseSocketServerUrl = 'http://10.0.2.2:5000/';

class SocketIo {
  late IO.Socket socket;
  SocketIo() {
    this.socket = IO.io(baseSocketServerUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    this.socket.connect();
  }
}
