/// Standard result model for async and sync operations
/// Provides a consistent structure for operation results with data and error information
class StandardResult {
  /// Result data from the operation
  final Object? data;

  /// Type information of the result data
  final String? dataType;

  /// Error message if the operation failed
  final String? errorMessage;

  /// Creates a StandardResult instance
  ///
  /// [data] - Optional result data from the operation
  /// [dataType] - Optional data type information
  /// [errorMessage] - Optional error message if operation failed
  StandardResult({
    this.data,
    this.dataType,
    this.errorMessage,
  });
}
