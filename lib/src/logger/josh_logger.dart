// User-facing logging system imports
import 'dart:developer' as developer;
import 'package:catching_josh/src/logger/utils/error_extractor.dart';
import 'package:catching_josh/src/logger/utils/log_formatter.dart';
import 'package:catching_josh/src/logger/utils/environment_utils.dart';

/// User-facing logging class for CatchingJosh package
/// Provides immediate logging capabilities with clean formatting
/// Designed for direct user usage - outputs logs instantly
/// Uses EnvironmentUtils for production/development environment detection
class JoshLogger {
  /// Creates a single formatted log line for error messages
  /// Returns a formatted string that can be used for simple error logging
  ///
  /// [errorMessage] - The error message to format
  /// Returns a formatted log line string
  static String singleLogLine(String errorMessage) {
    return LogFormatter.createContentLine('ErrorMessage', errorMessage);
  }

  /// Logs error information for async/sync operations with detailed formatting
  /// Outputs immediately to console for debugging
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
    final logLines = <String>[];

    logLines.add(LogFormatter.createTopLine('$errorTitle Error Summary'));

    if (errorMessage != null) {
      logLines
          .add(LogFormatter.createContentLine('ErrorMessage', errorMessage));
    }

    if (error != null) {
      logLines.add(LogFormatter.createContentLine('Error', error));
    }

    if (stackTrace != null) {
      final st = ErrorExtractor.extractFileAndLines(stackTrace);
      if (st.isNotEmpty) {
        logLines
            .add(LogFormatter.createContentLine('StackTrace', st.join(' → ')));
      }
    }

    logLines.add(LogFormatter.createBottomLine());

    developer.log(logLines.join('\n'), level: 1000);
  }

  /// Logs success information for async/sync operations with detailed formatting
  /// Outputs immediately to console (disabled in production)
  ///
  /// [result] - The result object to log
  /// [successTitle] - Optional title for the success log
  /// [successMessage] - Optional custom success message
  static void logResultSuccess({
    Object? result,
    String? successTitle,
    String? successMessage,
  }) {
    if (EnvironmentUtils.isProduction) return;

    final logLines = <String>[];

    logLines.add(LogFormatter.createTopLine('$successTitle Success Summary'));

    if (successMessage != null) {
      logLines.add(
          LogFormatter.createContentLine('SuccessMessage', successMessage));
    }

    if (result != null) {
      logLines.add(LogFormatter.createContentLine('ResultData', result));

      logLines.add(LogFormatter.createContentLine(
          'ResponseDataType', result.runtimeType.toString()));
    } else {
      logLines.add(LogFormatter.createContentLine('ResultData', 'Null'));
    }

    logLines.add(LogFormatter.createBottomLine());

    developer.log(logLines.join('\n'), level: 800);
  }

  /// Logs error information for HTTP responses with detailed formatting
  /// Outputs immediately to console for debugging network issues
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
    final logLines = <String>[];

    logLines.add(LogFormatter.createTopLine('Response Error Summary'));

    if (error != null) {
      logLines.add(LogFormatter.createContentLine('Error', error));
    }

    if (stackTrace != null) {
      final st = ErrorExtractor.extractFileAndLines(stackTrace);
      if (st.isNotEmpty) {
        logLines
            .add(LogFormatter.createContentLine('StackTrace', st.join(' → ')));
      }
    }

    if (errorMessage != null) {
      logLines
          .add(LogFormatter.createContentLine('ErrorMessage', errorMessage));
    }

    if (statusCode != null) {
      logLines.add(LogFormatter.createContentLine('StatusCode', statusCode));
    }

    if (requestUri != null) {
      logLines.add(LogFormatter.createContentLine('RequestUri', requestUri));
    }

    if (responseUri != null) {
      logLines.add(LogFormatter.createContentLine('ResponseUri', responseUri));
    }

    if (responseData != null) {
      logLines
          .add(LogFormatter.createContentLine('ResponseData', responseData));
    }

    logLines.add(LogFormatter.createBottomLine());

    developer.log(logLines.join('\n'), level: 1000);
  }

  /// Logs success information for HTTP responses with detailed formatting
  /// Outputs immediately to console (disabled in production)
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
    if (EnvironmentUtils.isProduction) return;

    final logLines = <String>[];

    logLines.add(LogFormatter.createTopLine('Response Success Summary'));

    if (successMessage != null) {
      logLines.add(
          LogFormatter.createContentLine('successMessage', successMessage));
    }

    if (statusCode != null) {
      logLines.add(LogFormatter.createContentLine('StatusCode', statusCode));
    }

    if (requestUri != null) {
      logLines.add(LogFormatter.createContentLine('RequestUri', requestUri));
    }

    if (responseUri != null) {
      logLines.add(LogFormatter.createContentLine('ResponseUri', responseUri));
    }

    if (responseData != null) {
      logLines
          .add(LogFormatter.createContentLine('ResponseData', responseData));

      logLines.add(LogFormatter.createContentLine(
          'ResponseDataType', responseData.runtimeType.toString()));
    } else {
      logLines.add(LogFormatter.createContentLine('ResponseData', 'Null'));
    }

    logLines.add(LogFormatter.createBottomLine());

    developer.log(logLines.join('\n'), level: 800);
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
