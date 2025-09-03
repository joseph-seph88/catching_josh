import 'dart:developer' as developer;

/// Represents a single log entry with type, message, and level information
class LogEntry {
  final LogType? type;
  final String? message;
  final int? level;

  LogEntry({
    this.type = LogType.resultError,
    this.message = '',
    this.level = 1000,
  });
}

/// Enum defining different types of log entries
enum LogType {
  resultSuccess,
  resultError,
  responseSuccess,
  responseError,
}

/// Single log buffer for internal batch logging system
///
/// Stores only the most recent log entry and outputs it when flush() is called.
/// Designed for efficient memory usage and optimal performance in batch processing.
/// Used by JoshLoggerInternal for buffered logging that gets flushed by Core functions.
sealed class JoshLogBuffer {
  static LogEntry _logEntry = LogEntry();

  /// Updates the buffer with a new log entry (overwrites previous entry)
  ///
  /// [logEntry] - The log entry to store in the buffer
  static void updateLog(LogEntry logEntry) {
    _logEntry = logEntry;
  }

  /// Flushes the buffered log entry to console output
  ///
  /// Outputs the most recent log entry based on its type and level.
  /// Skips empty messages to avoid unnecessary console output.
  static void flush() {
    final message = _logEntry.message ?? '';

    if (message.isEmpty) {
      return;
    }

    switch (_logEntry.type) {
      case LogType.resultSuccess:
        developer.log(_logEntry.message ?? '', level: _logEntry.level ?? 800);
        break;
      case LogType.resultError:
        developer.log(_logEntry.message ?? '', level: _logEntry.level ?? 1000);
        break;
      case LogType.responseSuccess:
        developer.log(_logEntry.message ?? '', level: _logEntry.level ?? 800);
        break;
      case LogType.responseError:
        developer.log(_logEntry.message ?? '', level: _logEntry.level ?? 1000);
        break;
      default:
        break;
    }
  }

  /// Clears the buffer by resetting to default LogEntry
  ///
  /// Useful for cleanup or when you want to ensure no pending logs remain.
  static void clear() {
    _logEntry = LogEntry();
  }
}
