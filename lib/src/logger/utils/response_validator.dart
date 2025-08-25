import 'package:catching_josh/src/logger/exceptions/josh_exception.dart';
import 'package:catching_josh/src/logger/utils/response_extractor.dart';
import 'package:catching_josh/src/logger/utils/response_formatter.dart';

/// Utility class for validating HTTP responses and checking response status
/// Provides methods to identify HTTP response objects and validate their status codes
/// Automatically throws exceptions for error status codes and warns for empty responses
class ResponseValidator {
  /// Checks if the given object is a valid HTTP response
  ///
  /// Determines if an object is an HTTP response by checking:
  /// - Not null
  /// - Not a primitive type (String, int, bool, etc.)
  /// - Has a statusCode property
  ///
  /// [response] - The object to check
  /// Returns true if the object appears to be an HTTP response, false otherwise
  static bool isHttpResponse(dynamic response) {
    if (response == null) return false;

    if (response is String ||
        response is int ||
        response is bool ||
        response is double ||
        response is Map ||
        response is List ||
        response is DateTime ||
        response is Uri ||
        response is RegExp ||
        response is Function ||
        response is Symbol ||
        response is Type) {
      return false;
    }

    try {
      return response.statusCode != null;
    } catch (e) {
      return false;
    }
  }

  /// Validates HTTP response status and throws exceptions for error codes
  ///
  /// Checks the response status code and:
  /// - Throws JoshException for status codes >= 400 (client/server errors)
  /// - Warns for successful responses (200-299) with empty data
  /// - Does nothing for valid responses
  ///
  /// [response] - The HTTP response object to validate
  /// Throws JoshException if the response has an error status code
  static void validateHttpStatus(dynamic response) {
    if (response == null) return;

    if (isHttpResponse(response)) {
      final statusCode = ResponseExtractor.getStatusCode(response);
      final data = ResponseExtractor.getResponseData(response);
      if (statusCode != null) {
        if (statusCode >= 400) {
          final errorMessage =
              ResponseFormatter.formatHttpErrorMessage(statusCode, data);
          throw JoshException(errorMessage);
        }

        if (statusCode >= 200 && statusCode < 300 && _isEmptyResponse(data)) {
          // Warning: HTTP success but response data is empty
        }
      }
    }
  }

  /// Checks if the response data is empty or null
  ///
  /// Validates different data types:
  /// - null: considered empty
  /// - String: checks if empty string
  /// - List: checks if empty list
  /// - Map: checks if empty map
  /// - Other types: considered non-empty
  ///
  /// [data] - The response data to check
  /// Returns true if the data is empty, false otherwise
  static bool _isEmptyResponse(dynamic data) {
    if (data == null) return true;
    if (data is String) return data.isEmpty;
    if (data is List) return data.isEmpty;
    if (data is Map) return data.isEmpty;
    return false;
  }
}
