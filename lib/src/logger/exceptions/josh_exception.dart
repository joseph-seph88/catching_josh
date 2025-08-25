/// Custom exception class for CatchingJosh package
/// Provides detailed error information with title, message, and stack trace
/// for better error handling and debugging capabilities
///
/// [error] - The original error object
/// [stackTrace] - Optional stack trace for debugging
/// [errorTitle] - Optional custom title for the error
/// [errorMessage] - Optional custom error message
///
class JoshException implements Exception {
  final Object? error;
  final StackTrace? stackTrace;
  final String? errorTitle;
  final String? errorMessage;

  JoshException(
    this.error, {
    this.stackTrace,
    this.errorTitle,
    this.errorMessage,
  });

  /// Returns a formatted string representation of the exception
  /// Format: [errorTitle] JoshException:: error
  @override
  String toString() => '[$errorTitle] JoshException:: $error';
}
