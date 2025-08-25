import 'dart:developer' as developer;

import 'package:catching_josh/src/logger/utils/error_extractor.dart';
import 'package:catching_josh/src/logger/utils/response_extractor.dart';
import 'package:catching_josh/src/logger/utils/response_validator.dart';
import 'package:catching_josh/src/logger/utils/log_formatter.dart';

/// Main logging class for CatchingJosh package
/// Provides comprehensive logging capabilities with beautiful formatting
/// for both error and success scenarios
class JoshLogger {
  /// Logs error information with detailed formatting
  ///
  /// [error] - The error object to log
  /// [stackTrace] - Optional stack trace for debugging
  /// [errorTitle] - Optional title for the error log
  /// [errorMessage] - Optional custom error message
  static void logError(
    Object error,
    StackTrace? stackTrace, {
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

    developer.log(LogFormatter.createContentLine('Error', error), level: 1000);

    if (stackTrace != null) {
      final st = ErrorExtractor.extractFileAndLine(stackTrace);
      if (st.isNotEmpty) {
        developer.log(LogFormatter.createContentLine('StackTrace', st),
            level: 1000);
      }
    }

    developer.log(LogFormatter.createBottomLine(), level: 1000);
  }

  /// Logs success information with detailed formatting
  ///
  /// [response] - The response object to log
  /// [successTitle] - Optional title for the success log
  /// [successMessage] - Optional custom success message
  static void logSuccess({
    Object? response,
    String? successTitle,
    String? successMessage,
  }) {
    developer.log(LogFormatter.createTopLine('$successTitle Success Summary'));

    if (response != null) {
      if (ResponseValidator.isHttpResponse(response)) {
        final responseData = response as dynamic;
        final responseDataType =
            ResponseExtractor.getResponseDataType(responseData);
        final responseResult = ResponseExtractor.getResponseData(responseData);

        if (successMessage != null) {
          developer.log(
              LogFormatter.createContentLine('SuccessMessage', successMessage));
        }

        developer.log(LogFormatter.createContentLine(
            'StatusCode', responseData.statusCode));
        developer
            .log(LogFormatter.createContentLine('DataType', responseDataType));
        developer.log(LogFormatter.createContentLine('Data', responseResult));
      } else {
        developer.log(
            LogFormatter.createContentLine('DataType', response.runtimeType));
        developer.log(LogFormatter.createContentLine('Data', response));
      }
    } else {
      developer.log(LogFormatter.createContentLine('Data', response));
    }

    developer.log(LogFormatter.createBottomLine());
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
