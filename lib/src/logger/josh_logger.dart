import 'dart:developer' as developer;
import 'package:catching_josh/src/logger/utils/error_extractor.dart';
import 'package:catching_josh/src/logger/utils/log_formatter.dart';

/// Main logging class for CatchingJosh package
/// Provides comprehensive logging capabilities with clean formatting
/// for both error and success scenarios
class JoshLogger {
  static bool get _isProduction {
    const environment =
        String.fromEnvironment('ENVIRONMENT', defaultValue: 'dev');
    return environment == 'prod' || environment == 'production';
  }

  /// Logs error information for async/sync operations with detailed formatting
  ///
  /// [error] - The error object to log
  /// [stackTrace] - Optional stack trace for debugging
  /// [errorTitle] - Optional title for the error log
  /// [errorMessage] - Optional custom error message
  static void logResultError({
    Object? error,
    StackTrace? stackTrace,
    String? errorTitle,
    String? errorMessage,
  }) {
    developer.log(
      LogFormatter.createTopLine('$errorTitle Error Summary'),
      level: 1000,
    );

    if (errorMessage != null) {
      developer.log(
          LogFormatter.createContentLine('ErrorMessage', errorMessage),
          level: 1000);
    }

    if (error != null) {
      developer.log(LogFormatter.createContentLine('Error', error),
          level: 1000);
    }

    if (stackTrace != null) {
      final st = ErrorExtractor.extractFileAndLines(stackTrace);
      if (st.isNotEmpty) {
        developer.log(
            LogFormatter.createContentLine('StackTrace', st.join(' → ')),
            level: 1000);
      }
    }

    developer.log(LogFormatter.createBottomLine(), level: 1000);
  }

  /// Logs success information for async/sync operations with detailed formatting
  ///
  /// [result] - The result object to log
  /// [successTitle] - Optional title for the success log
  /// [successMessage] - Optional custom success message
  static void logResultSuccess({
    Object? result,
    String? successTitle,
    String? successMessage,
  }) {
    if (_isProduction) return;

    developer.log(
      LogFormatter.createTopLine('$successTitle Success Summary'),
      level: 800,
    );

    if (successMessage != null) {
      developer.log(
          LogFormatter.createContentLine('SuccessMessage', successMessage),
          level: 800);
    }

    if (result != null) {
      developer.log(LogFormatter.createContentLine('ResultData', result),
          level: 800);
    }

    developer.log(
        LogFormatter.createContentLine(
            'ResultDataType', result.runtimeType.toString()),
        level: 800);

    developer.log(LogFormatter.createBottomLine(), level: 800);
  }

  /// Logs error information for HTTP responses with detailed formatting
  ///
  /// [errorMessage] - Optional custom error message
  /// [statusCode] - Optional HTTP status code
  /// [responseData] - Optional response data
  /// [requestUri] - Optional request URI
  /// [responseUri] - Optional response URI
  /// [error] - Optional error object
  /// [stackTrace] - Optional stack trace for debugging
  static void logResponseError({
    String? errorMessage,
    int? statusCode,
    dynamic responseData,
    String? requestUri,
    String? responseUri,
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      LogFormatter.createTopLine('Response Error Summary'),
      level: 1000,
    );

    if (error != null) {
      developer.log(LogFormatter.createContentLine('Error', error),
          level: 1000);
    }

    if (stackTrace != null) {
      final st = ErrorExtractor.extractFileAndLines(stackTrace);
      if (st.isNotEmpty) {
        developer.log(
            LogFormatter.createContentLine('StackTrace', st.join(' → ')),
            level: 1000);
      }
    }

    if (errorMessage != null) {
      developer.log(
          LogFormatter.createContentLine('ErrorMessage', errorMessage),
          level: 1000);
    }

    if (statusCode != null) {
      developer.log(LogFormatter.createContentLine('StatusCode', statusCode),
          level: 1000);
    }

    if (requestUri != null) {
      developer.log(LogFormatter.createContentLine('RequestUri', requestUri),
          level: 1000);
    }

    if (responseUri != null) {
      developer.log(LogFormatter.createContentLine('ResponseUri', responseUri),
          level: 1000);
    }

    if (responseData != null) {
      developer.log(
          LogFormatter.createContentLine('ResponseData', responseData),
          level: 1000);
    }

    developer.log(LogFormatter.createBottomLine(), level: 1000);
  }

  /// Logs success information for HTTP responses with detailed formatting
  ///
  /// [successMessage] - Optional custom success message
  /// [statusCode] - Optional HTTP status code
  /// [responseData] - Optional response data
  /// [requestUri] - Optional request URI
  /// [responseUri] - Optional response URI
  static void logResponseSuccess({
    String? successMessage,
    int? statusCode,
    dynamic responseData,
    String? requestUri,
    String? responseUri,
  }) {
    if (_isProduction) return;

    developer.log(
      LogFormatter.createTopLine('Response Success Summary'),
      level: 800,
    );

    if (successMessage != null) {
      developer.log(
          LogFormatter.createContentLine('successMessage', successMessage),
          level: 800);
    }

    if (statusCode != null) {
      developer.log(LogFormatter.createContentLine('StatusCode', statusCode),
          level: 800);
    }

    if (requestUri != null) {
      developer.log(LogFormatter.createContentLine('RequestUri', requestUri),
          level: 800);
    }

    if (responseUri != null) {
      developer.log(LogFormatter.createContentLine('ResponseUri', responseUri),
          level: 800);
    }

    if (responseData != null) {
      developer.log(
          LogFormatter.createContentLine('ResponseData', responseData),
          level: 800);
    } else {
      developer.log(LogFormatter.createContentLine('ResponseData', 'Null'),
          level: 800);
    }

    developer.log(LogFormatter.createBottomLine(), level: 800);
  }
}

/// Log level usage guide
///
/// Available log levels for developer.log:
/// - level: 0      - Trace messages (lowest level)
/// - level: 500    - Debug information
/// - level: 800    - General information
/// - level: 900    - Warning messages
/// - level: 1000   - Error messages
/// - level: 1200   - Fatal messages (highest level)
