import 'package:logger/logger.dart';

/// A singleton logger used to log route related messages.
class RouteLogger {
  static RouteLogger? _instance;
  Logger? __logger;
  Logger get _logger => __logger ??= Logger();

  RouteLogger._();

  factory RouteLogger() => _instance ??= RouteLogger._();

  /// Log a debug message.
  void d(String message) => _logger.d(message);

  /// Log a warning message.
  void w(String message) => _logger.w(message);

  /// Log an error message.
  void e(String message) => _logger.e(message);
}
