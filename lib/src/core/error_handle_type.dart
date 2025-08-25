/// Enum defining different error handling strategies for CatchingJosh functions
///
/// This enum provides three different ways to handle errors:
/// - returnNull: Return null when an error occurs (safe fallback)
/// - rethrowError: Rethrow the original error (preserves stack trace)
/// - throwError: Throw a new JoshException (custom error handling)
enum ErrorHandleType {
  returnNull('null'),
  rethrowError('rethrow'),
  throwError('throw');

  const ErrorHandleType(this.value);

  final String value;

  @override
  String toString() => value;
}
