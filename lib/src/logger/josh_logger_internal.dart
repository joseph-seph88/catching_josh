// Internal batch logging system imports
import 'package:catching_josh/src/logger/josh_log_buffer.dart';
import 'package:catching_josh/src/logger/utils/error_extractor.dart';
import 'package:catching_josh/src/logger/utils/log_formatter.dart';
import 'package:catching_josh/src/logger/utils/environment_utils.dart';

/// Internal logger class for handling result and response logging operations
/// Provides structured logging with formatted output for debugging and monitoring
/// Uses EnvironmentUtils for production/development environment detection
sealed class JoshLoggerInternal {
  /// Logs error information for async/sync operations with detailed formatting
  ///
  /// This method creates a formatted error log box containing:
  /// - Error title and summary
  /// - Custom error message (if provided)
  /// - Error object details
  /// - Stack trace with file and line information
  ///
  /// Parameters:
  /// - [error] - The error object to log
  /// - [stackTrace] - Optional stack trace for debugging
  /// - [errorTitle] - Optional title for the error log
  /// - [errorMessage] - Optional custom error message
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

    JoshLogBuffer.updateLog(LogEntry(
      type: LogType.resultError,
      message: logLines.join('\n'),
      level: 1000,
    ));
  }

  /// Logs success information for async/sync operations with detailed formatting
  ///
  /// This method creates a formatted success log box containing:
  /// - Success title and summary
  /// - Custom success message (if provided)
  /// - Result data and its type information
  ///
  /// Note: Success logs are disabled in production environment for performance
  ///
  /// Parameters:
  /// - [result] - The result object to log
  /// - [successTitle] - Optional title for the success log
  /// - [successMessage] - Optional custom success message
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

    JoshLogBuffer.updateLog(LogEntry(
      type: LogType.resultSuccess,
      message: logLines.join('\n'),
      level: 800,
    ));
  }

  /// Logs error information for HTTP responses with detailed formatting
  ///
  /// This method creates a formatted error log box containing:
  /// - Error object and stack trace information
  /// - Custom error message (if provided)
  /// - HTTP status code and URI information
  /// - Response data details
  ///
  /// Parameters:
  /// - [errorMessage] - Optional custom error message
  /// - [statusCode] - Optional HTTP status code
  /// - [responseData] - Optional response data
  /// - [requestUri] - Optional request URI
  /// - [responseUri] - Optional response URI
  /// - [error] - Optional error object
  /// - [stackTrace] - Optional stack trace for debugging
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

    JoshLogBuffer.updateLog(LogEntry(
      type: LogType.responseError,
      message: logLines.join('\n'),
      level: 1000,
    ));
  }

  /// Logs success information for HTTP responses with detailed formatting
  ///
  /// This method creates a formatted success log box containing:
  /// - Custom success message (if provided)
  /// - HTTP status code and URI information
  /// - Response data and its type information
  ///
  /// Note: Success logs are disabled in production environment for performance
  ///
  /// Parameters:
  /// - [successMessage] - Optional custom success message
  /// - [statusCode] - Optional HTTP status code
  /// - [responseData] - Optional response data
  /// - [requestUri] - Optional request URI
  /// - [responseUri] - Optional response URI
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

    JoshLogBuffer.updateLog(LogEntry(
      type: LogType.responseSuccess,
      message: logLines.join('\n'),
      level: 800,
    ));
  }
}
