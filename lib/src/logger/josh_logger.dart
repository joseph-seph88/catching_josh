import 'dart:developer' as developer;
import 'package:catching_josh/src/logger/utils/error_extractor.dart';
import 'package:catching_josh/src/logger/utils/response_extractor.dart';
import 'package:catching_josh/src/logger/utils/response_validator.dart';
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
    if (_isProduction) return;

    developer.log(
      LogFormatter.createTopLine('$successTitle Success Summary'),
      level: 800,
    );

    if (response != null) {
      if (ResponseValidator.isHttpResponse(response)) {
        final responseData = response as dynamic;
        final responseDataType =
            ResponseExtractor.getResponseDataType(responseData);
        final responseResult = ResponseExtractor.getResponseData(responseData);

        if (successMessage != null) {
          developer.log(
              LogFormatter.createContentLine('SuccessMessage', successMessage),
              level: 800);
        }

        developer.log(
            LogFormatter.createContentLine(
                'StatusCode', responseData.statusCode),
            level: 800);
        developer.log(
            LogFormatter.createContentLine('DataType', responseDataType),
            level: 800);
        developer.log(LogFormatter.createContentLine('Data', responseResult),
            level: 800);
      } else {
        developer.log(
            LogFormatter.createContentLine('DataType', response.runtimeType),
            level: 800);
        developer.log(LogFormatter.createContentLine('Data', response),
            level: 800);
      }
    } else {
      developer.log(LogFormatter.createContentLine('Data', response),
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
