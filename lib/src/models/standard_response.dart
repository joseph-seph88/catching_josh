/// Standard response model for HTTP API calls
/// Provides a consistent structure for all HTTP responses with status information and data
class StandardResponse {
  /// HTTP status code (e.g., 200, 404, 500)
  final int? statusCode;

  /// HTTP status message (e.g., "OK", "Not Found", "Internal Server Error")
  final String? statusMessage;

  /// Response data from the API call
  final dynamic data;

  /// Type information of the response data
  final String? dataType;

  final bool? isSuccess;

  /// Creates a StandardResponse instance
  ///
  /// [statusCode] - Optional HTTP status code
  /// [statusMessage] - Optional HTTP status message
  /// [data] - Optional response data
  /// [dataType] - Optional data type information
  StandardResponse({
    this.statusCode,
    this.statusMessage,
    this.data,
    this.dataType,
    this.isSuccess = false,
  });
}
