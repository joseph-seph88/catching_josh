// Core system imports
import 'package:catching_josh/src/handlers/result_handler.dart';
import 'package:catching_josh/src/handlers/response_handler.dart';
import 'package:catching_josh/src/models/standard_response.dart';
import 'package:catching_josh/src/models/standard_result.dart';

// Internal batch logging system imports
import 'package:catching_josh/src/logger/josh_log_buffer.dart';
import 'package:catching_josh/src/logger/josh_logger_internal.dart';
import 'package:catching_josh/src/logger/utils/environment_utils.dart';

/// Core Functions for CatchingJosh package
///
/// Provides centralized error handling with internal batch logging system.
/// All core functions use JoshLoggerInternal for buffered logging that gets
/// flushed at the end of each operation for optimal performance.
///
/// [joshSync] : Synchronous operations (file I/O, database operations)
/// [joshAsync] : Asynchronous operations (file I/O, database operations, service calls)
/// [joshReq] : HTTP API calls with standardized response handling and mock data support for testing
///
/// Function Parameters:
/// [function] : (Required) The function to execute
/// [logTitle] : (Optional) Custom title for logging messages
/// [errorMessage] : (Optional) Custom error message
/// [showSuccessLog] : (Optional) Whether to log success (default: false)
/// [showErrorLog] : (Optional) Whether to log errors (default: false)
/// [mockResponseOnCatch] : (Optional) Mock data to return in development when errors occur
/// [mockResultOnCatch] : (Optional) Mock data to return in development for sync/async when errors occur
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
  dynamic mockResultOnCatch,
  bool rethrowOnError = false,
  bool attachOriginalErrorMessage = false,
}) {
  try {
    final result = function();

    if (result is StandardResult) {
      if (showSuccessLog || showErrorLog) {
        JoshLogBuffer.flush();
      }
      return result;
    }
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
    if (rethrowOnError) rethrow;
    JoshLoggerInternal.logResultError(
      error: error,
      stackTrace: stackTrace,
      errorTitle: logTitle,
      errorMessage: errorMessage,
    );
    JoshLogBuffer.flush();

    return StandardResult(
      data: EnvironmentUtils.isDevelopment ? mockResultOnCatch : null,
      errorMessage: errorMessage ??
          (attachOriginalErrorMessage ? error.toString() : null),
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
  dynamic mockResultOnCatch,
  bool rethrowOnError = false,
  bool attachOriginalErrorMessage = false,
}) async {
  try {
    final result = await function();

    if (result is StandardResult) {
      if (showSuccessLog || showErrorLog) {
        JoshLogBuffer.flush();
      }
      return result;
    }

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
    if (rethrowOnError) rethrow;
    JoshLoggerInternal.logResultError(
      error: error,
      stackTrace: stackTrace,
      errorTitle: logTitle,
      errorMessage: errorMessage,
    );
    JoshLogBuffer.flush();

    return StandardResult(
      data: EnvironmentUtils.isDevelopment ? mockResultOnCatch : null,
      errorMessage: errorMessage ??
          (attachOriginalErrorMessage ? error.toString() : null),
      isSuccess: false,
    );
  }
}

/// HTTP API request wrapper with standardized response handling
/// Supports mock data fallback for testing and development environments
///
/// [function] - The HTTP request function to execute
/// [mockResponseOnCatch] - Optional mock data returned in development when errors occur
/// Returns a standardized response with consistent error handling
Future<StandardResponse> joshReq(
  Future<dynamic> Function() function, {
  dynamic mockResponseOnCatch,
  bool rethrowOnError = false,
  bool attachOriginalErrorMessage = false,
}) async {
  try {
    final response = await function();

    if (response is StandardResponse) {
      JoshLogBuffer.flush();
      return response;
    }
    final standardResponse = ResponseHandler.handleResponse(response);
    JoshLogBuffer.flush();

    return standardResponse;
  } catch (error, stackTrace) {
    if (rethrowOnError) rethrow;
    JoshLoggerInternal.logResponseError(
      errorMessage: 'Unknown Response Error',
      error: error,
      stackTrace: stackTrace,
    );
    JoshLogBuffer.flush();

    return StandardResponse(
      statusMessage: attachOriginalErrorMessage
          ? 'Unknown Response Error: ${error.toString()}'
          : 'Unknown Response Error',
      data: EnvironmentUtils.isDevelopment ? mockResponseOnCatch : null,
      isSuccess: false,
    );
  }
}
