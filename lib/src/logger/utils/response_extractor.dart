import 'dart:developer' as developer;

/// Utility class for extracting data from different types of HTTP responses
/// Supports multiple response types including http, dio, and custom response objects
/// Provides unified interface for accessing status codes, response data, and data types
class ResponseExtractor {
  /// Logs extraction errors for debugging purposes
  /// Only logs in debug mode to avoid production noise
  static void _extractDebugLog(String message) {
    assert(() {
      developer.log(
        message,
        level: 800,
        name: 'ResponseExtractor',
      );
      return true;
    }());
  }

  /// Extracts status code from HTTP response objects
  ///
  /// [response] - The response object (http.Response, dio.Response, etc.)
  /// Returns the status code if available, null otherwise
  static int? getStatusCode(dynamic response) {
    try {
      return response.statusCode;
    } catch (e) {
      _extractDebugLog(
          'ResponseExtractor: statusCode extraction failed - ${response.runtimeType}');
      return null;
    }
  }

  /// Extracts response data from different types of HTTP responses
  ///
  /// Attempts to extract data in the following order:
  /// 1. response.body (for http.Response)
  /// 2. response.data (for dio.Response)
  /// 3. response.content (for custom response objects)
  ///
  /// [response] - The response object to extract data from
  /// Returns the response data or null if extraction fails
  static dynamic getResponseData(dynamic response) {
    try {
      final body = response.body;
      if (body != null) {
        return body;
      }
    } catch (e) {
      _extractDebugLog(
          'ResponseExtractor: response.body extraction failed - ${response.runtimeType}');
    }

    try {
      final data = response.data;
      if (data != null) {
        return data;
      }
    } catch (e) {
      _extractDebugLog(
          'ResponseExtractor: response.data extraction failed - ${response.runtimeType}');
    }

    try {
      return response.content;
    } catch (e) {
      _extractDebugLog(
          'ResponseExtractor: response.content extraction failed - ${response.runtimeType}');
    }

    return null;
  }

  /// Extracts the runtime type of response data
  ///
  /// Attempts to determine the data type in the following order:
  /// 1. response.body.runtimeType (for http.Response)
  /// 2. response.data.runtimeType (for dio.Response)
  /// 3. response.content.runtimeType (for custom response objects)
  ///
  /// [response] - The response object to extract type information from
  /// Returns the runtime type of the response data or null if extraction fails
  static Type? getResponseDataType(dynamic response) {
    try {
      return response.body.runtimeType;
    } catch (e) {
      _extractDebugLog(
          'ResponseExtractor: response.body.runtimeType extraction failed - ${response.runtimeType}');
    }

    try {
      return response.data.runtimeType;
    } catch (e) {
      _extractDebugLog(
          'ResponseExtractor: response.data.runtimeType extraction failed - ${response.runtimeType}');
    }

    try {
      return response.content.runtimeType;
    } catch (e) {
      _extractDebugLog(
          'ResponseExtractor: response.content.runtimeType extraction failed - ${response.runtimeType}');
    }

    return null;
  }
}
