/// Utility class for extracting file and line information from stack traces
/// Helps developers quickly identify the source location of errors
class ErrorExtractor {
  /// Regular expression to extract file path and line numbers
  /// Pattern: (file_path:line_number:column_number)
  static final RegExp _fileLineRegex = RegExp(r'\((.+):(\d+):(\d+)\)');

  /// Extracts file name and line number from a stack trace
  ///
  /// [stackTrace] - The stack trace to extract information from
  /// Returns formatted string like 'main.dart:25' or full stack trace if extraction fails
  static String extractFileAndLine(StackTrace stackTrace) {
    try {
      final lines = stackTrace.toString().split('\n');

      for (final line in lines.take(5)) {
        final match = _fileLineRegex.firstMatch(line);
        if (match != null) {
          final fileName = match.group(1)?.split('/').last ?? 'unknown';
          final lineNumber = match.group(2) ?? '?';
          return '$fileName:$lineNumber';
        }
      }
    } catch (e) {
      return stackTrace.toString();
    }

    return stackTrace.toString();
  }
}
