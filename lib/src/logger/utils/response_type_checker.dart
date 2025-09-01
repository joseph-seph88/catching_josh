/// Utility class for checking response types and success indicators
/// Helps identify different types of HTTP responses and determine their success status
class ResponseTypeChecker {
  /// Checks if the response is a Dio response
  ///
  /// [response] - The response object to check
  /// Returns true if the response has Dio-specific properties (statusMessage and requestOptions)
  static bool isDio(dynamic response) {
    try {
      return response.statusMessage != null && response.requestOptions != null;
    } catch (e) {
      return false;
    }
  }

  /// Checks if the response is a standard HTTP response
  ///
  /// [response] - The response object to check
  /// Returns true if the response has HTTP-specific properties (reasonPhrase and request)
  static bool isHttp(dynamic response) {
    try {
      return response.reasonPhrase != null && response.request != null;
    } catch (e) {
      return false;
    }
  }

  /// Checks if the response indicates success
  ///
  /// [response] - The response object to check
  /// Returns true if the response indicates success based on:
  /// - Status code between 200-299 (success range)
  /// - Absence of error indicators (error, exception, error message)
  static bool hasSuccessIndicator(dynamic response) {
    try {
      final statusCode = response.statusCode ?? response.status;
      if (statusCode != null) {
        return statusCode >= 200 && statusCode < 300;
      }

      final hasError = response.error != null ||
          response.exception != null ||
          response.message?.toString().toLowerCase().contains('error') == true;

      return !hasError;
    } catch (e) {
      return false;
    }
  }
}
