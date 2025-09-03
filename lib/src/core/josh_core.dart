// Core system imports
import 'package:catching_josh/src/handlers/result_handler.dart';
import 'package:catching_josh/src/handlers/response_handler.dart';
import 'package:catching_josh/src/models/standard_response.dart';
import 'package:catching_josh/src/models/standard_result.dart';

// Internal batch logging system imports
import 'package:catching_josh/src/logger/josh_log_buffer.dart';
import 'package:catching_josh/src/logger/josh_logger_internal.dart';

/// Core Functions for CatchingJosh package
///
/// Provides centralized error handling with internal batch logging system.
/// All core functions use JoshLoggerInternal for buffered logging that gets
/// flushed at the end of each operation for optimal performance.
///
/// [joshSync] : Synchronous operations (file I/O, database operations)
/// [joshAsync] : Asynchronous operations (file I/O, database operations, service calls)
/// [joshReq] : HTTP API calls with standardized response handling
///
/// Function Parameters:
/// [function] : (Required) The function to execute
/// [logTitle] : (Optional) Custom title for logging messages
/// [errorMessage] : (Optional) Custom error message
/// [showSuccessLog] : (Optional) Whether to log success (default: false)
/// [showErrorLog] : (Optional) Whether to log errors (default: false)
///
/// Return Types:
/// - joshSync: `StandardResult`
/// - joshAsync: `Future<StandardResult>`
/// - joshReq: `Future<StandardResponse>`

StandardResult joshSync<T>(
  T Function() function, {
  String? logTitle,
  String? errorMessage,
  bool showSuccessLog = false,
  bool showErrorLog = false,
}) {
  try {
    final result = function();
    final standardResult = ResultHandler.syncHandleResult(
      result: result,
      logTitle: logTitle,
      errorMessage: errorMessage,
      showSuccessLog: showSuccessLog,
      showErrorLog: showErrorLog,
    );

    if (showSuccessLog || showErrorLog) {
      JoshLogBuffer.flush();
    }

    return standardResult;
  } catch (error, stackTrace) {
    JoshLoggerInternal.logResultError(
      error: error,
      stackTrace: stackTrace,
      errorTitle: logTitle,
      errorMessage: errorMessage,
    );
    JoshLogBuffer.flush();

    return StandardResult(
      errorMessage: errorMessage,
      isSuccess: false,
    );
  }
}

Future<StandardResult> joshAsync<T>(
  Future<T> Function() function, {
  String? logTitle,
  String? errorMessage,
  bool showSuccessLog = false,
  bool showErrorLog = false,
}) async {
  try {
    final result = await function();

    final standardResult = ResultHandler.asyncHandleResult(
      result: result,
      logTitle: logTitle,
      errorMessage: errorMessage,
      showSuccessLog: showSuccessLog,
      showErrorLog: showErrorLog,
    );

    if (showSuccessLog || showErrorLog) {
      JoshLogBuffer.flush();
    }

    return standardResult;
  } catch (error, stackTrace) {
    JoshLoggerInternal.logResultError(
      error: error,
      stackTrace: stackTrace,
      errorTitle: logTitle,
      errorMessage: errorMessage,
    );
    JoshLogBuffer.flush();

    return StandardResult(
      errorMessage: errorMessage,
      isSuccess: false,
    );
  }
}

Future<StandardResponse> joshReq(
  Future<dynamic> Function() function,
) async {
  try {
    final response = await function();
    final standardResponse = ResponseHandler.handleResponse(response);
    JoshLogBuffer.flush();

    return standardResponse;
  } catch (error, stackTrace) {
    JoshLoggerInternal.logResponseError(
      errorMessage: 'Unknown Response Error',
      error: error,
      stackTrace: stackTrace,
    );
    JoshLogBuffer.flush();

    return StandardResponse(
      statusMessage: 'Unknown Response Error',
      isSuccess: false,
    );
  }
}
