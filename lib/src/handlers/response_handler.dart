import 'package:catching_josh/catching_josh.dart';

/// Handler class for processing HTTP responses and converting them to StandardResponse
/// Supports different response types: Dio, HTTP, and custom responses
class ResponseHandler {
  /// Main method to handle any type of response and convert it to StandardResponse
  ///
  /// [response] - The response object to process (can be Dio, HTTP, or custom type)
  /// Returns a StandardResponse with standardized format and appropriate logging
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
    } catch (e, s) {
      JoshLogger.logResponseError(error: e, stackTrace: s);
      return StandardResponse(statusMessage: 'Unknown Response Error');
    }
  }

  /// Handles null responses
  ///
  /// Returns a StandardResponse indicating null response with appropriate error logging
  static StandardResponse _handleNullResponse() {
    JoshLogger.logResponseError(errorMessage: 'Response is Null');
    return StandardResponse(statusMessage: 'Response is Null');
  }

  /// Handles custom/default responses that are not Dio or HTTP
  ///
  /// [response] - The custom response object to process
  /// Returns a StandardResponse with success/error determination based on response content
  static StandardResponse _handleDefaultResponse(dynamic response) {
    final hasSuccessIndicator =
        ResponseTypeChecker.hasSuccessIndicator(response);

    if (hasSuccessIndicator) {
      JoshLogger.logResponseSuccess(
        successMessage: 'Response is Success',
        responseData: response,
      );
    } else {
      JoshLogger.logResponseError(
        errorMessage: 'Response is Error',
        responseData: response,
      );
    }

    return StandardResponse(
      statusMessage:
          hasSuccessIndicator ? 'Response is Success' : 'Response is Error',
      data: response,
      dataType: response.runtimeType.toString(),
    );
  }

  /// Handles standard HTTP responses
  ///
  /// [response] - The HTTP response object to process
  /// Returns a StandardResponse with HTTP-specific information (statusCode, reasonPhrase, body)
  static StandardResponse _handleHttpResponse(dynamic response) {
    final hasSuccessIndicator =
        ResponseTypeChecker.hasSuccessIndicator(response);
    final statusMessage = response.reasonPhrase;
    final statusCode = response.statusCode;
    final responseData = response.body;
    final requestUri = response.request?.url;

    if (hasSuccessIndicator) {
      JoshLogger.logResponseSuccess(
        successMessage: statusMessage,
        statusCode: statusCode,
        responseData: responseData,
        requestUri: requestUri,
      );
    } else {
      JoshLogger.logResponseError(
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
    );
  }

  /// Handles Dio HTTP client responses
  ///
  /// [response] - The Dio response object to process
  /// Returns a StandardResponse with Dio-specific information (statusCode, statusMessage, data)
  static StandardResponse _handleDioResponse(dynamic response) {
    final hasSuccessIndicator =
        ResponseTypeChecker.hasSuccessIndicator(response);
    final statusMessage = response.statusMessage;
    final statusCode = response.statusCode;
    final responseData = response.data;
    final requestUri = response.requestOptions.uri;
    final responseUri = response.realUri;

    if (hasSuccessIndicator) {
      JoshLogger.logResponseSuccess(
        successMessage: statusMessage,
        statusCode: statusCode,
        responseData: responseData,
        requestUri: requestUri,
        responseUri: responseUri,
      );
    } else {
      JoshLogger.logResponseError(
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
    );
  }
}
