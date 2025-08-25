import 'package:catching_josh/src/logger/utils/response_validator.dart';

/// Utility class for formatting HTTP responses and error messages
/// Provides methods to convert response objects to readable strings
/// and generate user-friendly HTTP error messages
class ResponseFormatter {
  /// Converts various response types to formatted strings
  ///
  /// Handles different data types:
  /// - Map: key-value pairs joined with commas
  /// - List: items joined with commas
  /// - String: returned as-is
  /// - Other: converted using toString()
  ///
  /// [response] - The response object to format
  /// Returns a formatted string representation of the response
  static String formatTypeToString(Object response) {
    if (response is Map) {
      return response.entries
          .map((entry) => '${entry.key}: ${entry.value}')
          .join(', ');
    } else if (response is List) {
      return response.map((item) => item.toString()).join(', ');
    } else if (response is String) {
      return response;
    } else {
      return response.toString();
    }
  }

  /// Formats HTTP responses to readable strings
  ///
  /// If the response is a valid HTTP response, formats it with status code and data.
  /// Otherwise, falls back to general type formatting.
  ///
  /// [response] - The HTTP response object to format
  /// Returns a formatted string with status and data information
  static String formatHttpToString(dynamic response) {
    if (ResponseValidator.isHttpResponse(response)) {
      final status = response.statusCode;
      final data = response.data ?? response.body;
      return 'Status: $status, Data: ${formatTypeToString(data)}';
    }

    return formatTypeToString(response);
  }

  /// Generates user-friendly HTTP error messages
  ///
  /// Converts HTTP status codes to human-readable Korean messages
  /// and appends any error details from the response data.
  ///
  /// [statusCode] - The HTTP status code
  /// [data] - Optional response data containing error details
  /// Returns a formatted error message in Korean
  static String formatHttpErrorMessage(int statusCode, dynamic data) {
    String message = 'HTTP $statusCode Error';

    switch (statusCode) {
      case 400:
        message = 'Bad Request (400)';
        break;
      case 401:
        message = 'Unauthorized (401)';
        break;
      case 403:
        message = 'Forbidden (403)';
        break;
      case 404:
        message = 'Not Found (404)';
        break;
      case 500:
        message = 'Internal Server Error (500)';
        break;
      case 502:
        message = 'Bad Gateway (502)';
        break;
      case 503:
        message = 'Service Unavailable (503)';
        break;
    }

    if (data != null && data is Map) {
      final errorMsg = data['message'] ?? data['error'] ?? data['msg'];
      if (errorMsg != null) {
        message += ': $errorMsg';
      }
    }

    return message;
  }
}
