import 'package:catching_josh/src/core/error_handle_type.dart';
import 'package:catching_josh/src/logger/exceptions/josh_exception.dart';
import 'package:catching_josh/src/logger/josh_logger.dart';
import 'package:catching_josh/src/logger/utils/response_validator.dart';

/// Core Functions for CatchingJosh package
/// [joshSync] : Local data access, file operations, database operations, and other sync tasks
/// [joshAsync] : Asynchronous operations like API calls, file I/O, database operations
/// [joshReq] : HTTP requests, network calls, and external API calls with response validation

/// Parameters for all functions:
/// [function] : (Required) The function to execute
/// [errorHandleType] : (Optional) Error handling strategy (null, throw, rethrow)
/// [messageTitle] : (Optional) Custom title for logging messages
/// [errorMessage] : (Optional) Custom error message
/// [showSuccessLog] : (Optional) Whether to log success (default: true)
/// [showErrorLog] : (Optional) Whether to log errors (default: true)

T? joshSync<T>(
  T Function() function, {
  ErrorHandleType errorHandleType = ErrorHandleType.throwError,
  String? messageTitle,
  String? errorMessage,
  bool showSuccessLog = false,
  bool showErrorLog = false,
}) {
  try {
    final response = function();

    if (showSuccessLog) {
      _handleSuccess<T>(response, messageTitle);
    }

    return response;
  } catch (error, stackTrace) {
    if (errorHandleType == ErrorHandleType.rethrowError) {
      rethrow;
    } else {
      return _handleError<T>(
        error,
        stackTrace,
        errorHandleType,
        errorTitle: messageTitle,
        errorMessage: errorMessage,
        showLog: showErrorLog,
      );
    }
  }
}

Future<T?> joshAsync<T>(
  Future<T> Function() function, {
  ErrorHandleType errorHandleType = ErrorHandleType.throwError,
  String? messageTitle,
  String? errorMessage,
  bool showSuccessLog = false,
  bool showErrorLog = false,
}) async {
  try {
    final response = await function();

    if (showSuccessLog) {
      _handleSuccess<T>(response, messageTitle);
    }

    return response;
  } catch (error, stackTrace) {
    if (errorHandleType == ErrorHandleType.rethrowError) {
      rethrow;
    } else {
      return _handleError<T>(
        error,
        stackTrace,
        errorHandleType,
        errorTitle: messageTitle,
        errorMessage: errorMessage,
        showLog: showErrorLog,
      );
    }
  }
}

Future<T> joshReq<T>(
  Future<T> Function() function, {
  ErrorHandleType errorHandleType = ErrorHandleType.throwError,
  String? messageTitle,
  String? errorMessage,
  bool showSuccessLog = false,
  bool showErrorLog = false,
}) async {
  try {
    final response = await function();

    if (response == null) {
      throw JoshException(
        Exception('Response is Null'),
        errorTitle: messageTitle,
      );
    }

    ResponseValidator.validateHttpStatus(response);

    if (showSuccessLog) {
      _handleSuccess<T>(response, messageTitle);
    }

    return response;
  } catch (error, stackTrace) {
    if (errorHandleType == ErrorHandleType.rethrowError) {
      rethrow;
    } else {
      return _requestHandleError<T>(
        error,
        stackTrace,
        errorTitle: messageTitle,
        errorMessage: errorMessage,
      );
    }
  }
}

/// Internal method to handle success logging
void _handleSuccess<T>(T? response, String? messageTitle) {
  JoshLogger.logSuccess(
    response: response,
    successTitle: messageTitle,
  );
}

/// Internal method to handle errors based on error handling type
T? _handleError<T>(
  Object error,
  StackTrace? stackTrace,
  ErrorHandleType errorHandleType, {
  String? errorTitle,
  String? errorMessage,
  bool showLog = false,
}) {
  if (showLog) {
    JoshLogger.logError(
      error,
      stackTrace,
      errorTitle: errorTitle,
      errorMessage: errorMessage,
    );
  }

  switch (errorHandleType) {
    case ErrorHandleType.returnNull:
      return null;
    default:
      throw JoshException(error, errorTitle: errorTitle);
  }
}

/// Internal method to handle request-specific errors
T _requestHandleError<T>(
  Object error,
  StackTrace? stackTrace, {
  String? errorTitle,
  String? errorMessage,
  bool showLog = false,
}) {
  if (showLog) {
    JoshLogger.logError(
      error,
      stackTrace,
      errorTitle: errorTitle,
      errorMessage: errorMessage,
    );
  }

  throw JoshException(error, errorTitle: errorTitle);
}
