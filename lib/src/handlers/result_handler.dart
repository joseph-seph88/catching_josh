import 'package:catching_josh/catching_josh.dart';

/// Handler class for processing async and sync operation results
/// Converts operation results to StandardResult format with optional logging
class ResultHandler {
  /// Handles asynchronous operation results
  ///
  /// [result] - The result object from the async operation
  /// [logTitle] - Optional title for logging messages
  /// [errorMessage] - Optional custom error message
  /// [showSuccessLog] - Whether to log success (default: false)
  /// [showErrorLog] - Whether to log errors (default: false)
  /// Returns a StandardResult with the operation result and optional logging
  static StandardResult asyncHandleResult({
    Object? result,
    String? logTitle,
    String? errorMessage,
    bool showSuccessLog = false,
    bool showErrorLog = false,
  }) {
    try {
      if (showSuccessLog) {
        JoshLogger.logResultSuccess(result: result, successTitle: logTitle);
      }
      return StandardResult(
          data: result, dataType: result.runtimeType.toString());
    } catch (error, stackTrace) {
      if (showErrorLog) {
        JoshLogger.logResultError(
          error: error,
          stackTrace: stackTrace,
          errorTitle: logTitle,
          errorMessage: errorMessage,
        );
      }
      return StandardResult(errorMessage: errorMessage);
    }
  }

  /// Handles synchronous operation results
  ///
  /// [result] - The result object from the sync operation
  /// [logTitle] - Optional title for logging messages
  /// [errorMessage] - Optional custom error message
  /// [showSuccessLog] - Whether to log success (default: false)
  /// [showErrorLog] - Whether to log errors (default: false)
  /// Returns a StandardResult with the operation result and optional logging
  static StandardResult syncHandleResult({
    Object? result,
    String? logTitle,
    String? errorMessage,
    bool showSuccessLog = false,
    bool showErrorLog = false,
  }) {
    try {
      if (showSuccessLog) {
        JoshLogger.logResultSuccess(result: result, successTitle: logTitle);
      }
      return StandardResult(
          data: result, dataType: result.runtimeType.toString());
    } catch (error, stackTrace) {
      if (showErrorLog) {
        JoshLogger.logResultError(
          error: error,
          stackTrace: stackTrace,
          errorTitle: logTitle,
          errorMessage: errorMessage,
        );
      }
      return StandardResult(errorMessage: errorMessage);
    }
  }
}
