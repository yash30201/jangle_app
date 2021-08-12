import 'package:get_it/get_it.dart';
import 'package:jangle_app/services/httpRequests.dart';
import 'package:jangle_app/services/socketio.dart';

final locator = GetIt.instance;

void setup() {
  locator.registerLazySingleton<HttpRequests>(() => HttpRequests());
  locator.registerLazySingleton<SocketIo>(() => SocketIo());
}
