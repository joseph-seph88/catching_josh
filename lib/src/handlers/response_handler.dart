// Handler system imports
import 'package:catching_josh/catching_josh.dart';
import 'package:catching_josh/src/logger/josh_logger_internal.dart';

/// Handler class for processing HTTP responses and converting them to StandardResponse
/// Supports different response types: Dio, HTTP, and custom responses
/// Uses JoshLoggerInternal for buffered logging that gets flushed by the calling Core
sealed class ResponseHandler {
  /// Main method to handle any type of response and convert it to StandardResponse
  ///
  /// This method processes various response types and logs them using the internal
  /// batch logging system. Logs are buffered and will be flushed by the calling Core.
  ///
  /// Parameters:
  /// - [response] - The response object to process (can be Dio, HTTP, or custom type)
  ///
  /// Returns a StandardResponse with standardized format and internal logging
  static StandardResponse handleResponse(dynamic response) {
    try {
      if (response == null) {
        return _handleNullResponse();
      } else if (ResponseTypeChecker.isHttp(response)) {
        return _handleHttpResponse(response);
      } else if (ResponseTypeChecker.isDio(response)) {
        return _handleDioResponse(response);
      } else {
        return _handleDefaultResponse(response);
      }
    } catch (error, stackTrace) {
      JoshLoggerInternal.logResponseError(error: error, stackTrace: stackTrace);
      return StandardResponse(
        statusMessage: error.toString(),
        isSuccess: false,
      );
    }
  }

  /// Handles null responses with internal batch logging
  ///
  /// This method processes null responses and logs them using the internal
  /// batch logging system. Logs are buffered and will be flushed by the calling Core.
  ///
  /// Returns a StandardResponse indicating null response with internal error logging
  static StandardResponse _handleNullResponse() {
    JoshLoggerInternal.logResponseError(errorMessage: 'Response is Null');
    return StandardResponse(
      statusMessage: 'Response is Null',
      isSuccess: false,
    );
  }

  /// Handles custom/default responses that are not Dio or HTTP with internal batch logging
  ///
  /// This method processes custom responses and logs them using the internal
  /// batch logging system. Logs are buffered and will be flushed by the calling Core.
  ///
  /// Parameters:
  /// - [response] - The custom response object to process
  ///
  /// Returns a StandardResponse with success/error determination and internal logging
  static StandardResponse _handleDefaultResponse(dynamic response) {
    final hasSuccessIndicator =
        ResponseTypeChecker.hasSuccessIndicator(response);

    if (hasSuccessIndicator) {
      JoshLoggerInternal.logResponseSuccess(
        successMessage: 'Response is Success',
        responseData: response,
      );
    } else {
      JoshLoggerInternal.logResponseError(
        errorMessage: 'Response is Error',
        responseData: response,
      );
    }

    return StandardResponse(
      statusMessage:
          hasSuccessIndicator ? 'Response is Success' : 'Response is Error',
      data: response,
      dataType: response.runtimeType.toString(),
      isSuccess: hasSuccessIndicator,
    );
  }

  /// Handles standard HTTP responses with internal batch logging
  ///
  /// This method processes HTTP responses and logs them using the internal
  /// batch logging system. Logs are buffered and will be flushed by the calling Core.
  ///
  /// Parameters:
  /// - [response] - The HTTP response object to process
  ///
  /// Returns a StandardResponse with HTTP-specific information and internal logging
  static StandardResponse _handleHttpResponse(dynamic response) {
    final hasSuccessIndicator =
        ResponseTypeChecker.hasSuccessIndicator(response);
    final statusMessage = response.reasonPhrase;
    final statusCode = response.statusCode;
    final responseData = response.body;
    final requestUri = response.request?.url;

    if (hasSuccessIndicator) {
      JoshLoggerInternal.logResponseSuccess(
        successMessage: statusMessage,
        statusCode: statusCode,
        responseData: responseData,
        requestUri: requestUri,
      );
    } else {
      JoshLoggerInternal.logResponseError(
        errorMessage: statusMessage,
        statusCode: statusCode,
        responseData: responseData,
        requestUri: requestUri,
      );
    }

    return StandardResponse(
      statusMessage: statusMessage,
      statusCode: statusCode,
      data: responseData,
      dataType: responseData.runtimeType.toString(),
      isSuccess: hasSuccessIndicator,
    );
  }

  /// Handles Dio HTTP client responses with internal batch logging
  ///
  /// This method processes Dio responses and logs them using the internal
  /// batch logging system. Logs are buffered and will be flushed by the calling Core.
  ///
  /// Parameters:
  /// - [response] - The Dio response object to process
  ///
  /// Returns a StandardResponse with Dio-specific information and internal logging
  static StandardResponse _handleDioResponse(dynamic response) {
    final hasSuccessIndicator =
        ResponseTypeChecker.hasSuccessIndicator(response);
    final statusMessage = response.statusMessage;
    final statusCode = response.statusCode;
    final responseData = response.data;
    final requestUri = response.requestOptions.uri;
    final responseUri = response.realUri;

    if (hasSuccessIndicator) {
      JoshLoggerInternal.logResponseSuccess(
        successMessage: statusMessage,
        statusCode: statusCode,
        responseData: responseData,
        requestUri: requestUri,
        responseUri: responseUri,
      );
    } else {
      JoshLoggerInternal.logResponseError(
        errorMessage: statusMessage,
        statusCode: statusCode,
        responseData: responseData,
        requestUri: requestUri,
        responseUri: responseUri,
      );
    }

    return StandardResponse(
      statusMessage: statusMessage,
      statusCode: statusCode,
      data: responseData,
      dataType: responseData.runtimeType.toString(),
      isSuccess: hasSuccessIndicator,
    );
  }
}
