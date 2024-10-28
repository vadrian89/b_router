import 'package:logger/logger.dart';

class AppLogger {
  static AppLogger? _instance;
  Logger? __loggerInstance;
  Logger get _loggerInstance => __loggerInstance ??= Logger();

  AppLogger._();
  factory AppLogger() => _instance ??= AppLogger._();

  void i(String message, {DateTime? time, Object? error, StackTrace? stackTrace}) =>
      _loggerInstance.i(message, time: time, error: error, stackTrace: stackTrace);

  void d(String message, {DateTime? time, Object? error, StackTrace? stackTrace}) =>
      _loggerInstance.d(message, time: time, error: error, stackTrace: stackTrace);

  void e(String message, {DateTime? time, Object? error, StackTrace? stackTrace}) =>
      _loggerInstance.e(message, time: time, error: error, stackTrace: stackTrace);
}
