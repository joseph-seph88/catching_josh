/// Utility class for extracting file and line information from stack traces
/// Helps developers quickly identify the source location of errors
class ErrorExtractor {
  /// Regular expression to extract file path and line numbers
  /// Pattern: (file_path:line_number:column_number)
  static final RegExp _fileLineRegex = RegExp(r'\((.+):(\d+):(\d+)\)');

  /// Extracts file name and line number from a stack trace
  ///
  /// [stackTrace] - The stack trace to extract information from
  /// Returns a list of formatted strings like 'main.dart:25' or full stack trace if extraction fails
  /// Only includes files from 'lib/' or 'test/' directories for better readability
  static List<String> extractFileAndLines(StackTrace stackTrace) {
    final results = <String>[];

    try {
      final lines = stackTrace.toString().split('\n');

      for (final line in lines.take(5)) {
        final match = _fileLineRegex.firstMatch(line);
        if (match != null) {
          final filePath = match.group(1) ?? '';
          final lineNumber = match.group(2) ?? '?';

          if (filePath.contains('lib/') || filePath.contains('test/')) {
            final fileName = filePath.split('/').last;
            results.add('$fileName:$lineNumber');
          }
        }
      }
      return results;
    } catch (e) {
      return [stackTrace.toString()];
    }
  }
}
