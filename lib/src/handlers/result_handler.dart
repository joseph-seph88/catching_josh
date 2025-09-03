// Handler system imports
import 'package:catching_josh/catching_josh.dart';
import 'package:catching_josh/src/logger/josh_logger_internal.dart';

/// Handler class for processing async and sync operation results
/// Converts operation results to StandardResult format with internal batch logging
/// Uses JoshLoggerInternal for buffered logging that gets flushed by the calling Core
sealed class ResultHandler {
  /// Handles asynchronous operation results with internal batch logging
  ///
  /// This method processes async operation results and logs them using the internal
  /// batch logging system. Logs are buffered and will be flushed by the calling Core.
  ///
  /// Parameters:
  /// - [result] - The result object from the async operation
  /// - [logTitle] - Optional title for logging messages
  /// - [errorMessage] - Optional custom error message
  /// - [showSuccessLog] - Whether to log success (default: false)
  /// - [showErrorLog] - Whether to log errors (default: false)
  ///
  /// Returns a StandardResult with the operation result and internal logging
  static StandardResult asyncHandleResult({
    Object? result,
    String? logTitle,
    String? errorMessage,
    bool showSuccessLog = false,
    bool showErrorLog = false,
  }) {
    try {
      if (showSuccessLog) {
        JoshLoggerInternal.logResultSuccess(
            result: result, successTitle: logTitle);
      }
      return StandardResult(
        data: result,
        dataType: result.runtimeType.toString(),
        isSuccess: true,
      );
    } catch (error, stackTrace) {
      if (showErrorLog) {
        JoshLoggerInternal.logResultError(
          error: error,
          stackTrace: stackTrace,
          errorTitle: logTitle,
          errorMessage: errorMessage,
        );
      }
      return StandardResult(
        errorMessage: error.toString(),
        isSuccess: false,
      );
    }
  }

  /// Handles synchronous operation results with internal batch logging
  ///
  /// This method processes sync operation results and logs them using the internal
  /// batch logging system. Logs are buffered and will be flushed by the calling Core.
  ///
  /// Parameters:
  /// - [result] - The result object from the sync operation
  /// - [logTitle] - Optional title for logging messages
  /// - [errorMessage] - Optional custom error message
  /// - [showSuccessLog] - Whether to log success (default: false)
  /// - [showErrorLog] - Whether to log errors (default: false)
  ///
  /// Returns a StandardResult with the operation result and internal logging
  static StandardResult syncHandleResult({
    Object? result,
    String? logTitle,
    String? errorMessage,
    bool showSuccessLog = false,
    bool showErrorLog = false,
  }) {
    try {
      if (showSuccessLog) {
        JoshLoggerInternal.logResultSuccess(
          result: result,
          successTitle: logTitle,
        );
      }
      return StandardResult(
        data: result,
        dataType: result.runtimeType.toString(),
        isSuccess: true,
      );
    } catch (error, stackTrace) {
      if (showErrorLog) {
        JoshLoggerInternal.logResultError(
          error: error,
          stackTrace: stackTrace,
          errorTitle: logTitle,
          errorMessage: errorMessage,
        );
      }
      return StandardResult(
        errorMessage: error.toString(),
        isSuccess: false,
      );
    }
  }
}
