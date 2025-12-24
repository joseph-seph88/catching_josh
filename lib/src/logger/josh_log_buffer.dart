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

  // Scoped logging support
  static final List<List<LogEntry>> _scopeStack = <List<LogEntry>>[];
  static bool get inScope => _scopeStack.isNotEmpty;
  static int get scopeDepth => _scopeStack.length;

  /// Begins a new logging scope. Logs produced while in a scope will be
  /// accumulated and only emitted when [flushAll] or [endScope] is called.
  static void beginScope() {
    _scopeStack.add(<LogEntry>[]);
  }

  /// Ends the current logging scope. If [flush] is true (default), all logs in
  /// the current scope are emitted in the order they were added.
  /// If [flush] is false, accumulated logs are discarded.
  static void endScope({bool flush = true}) {
    if (_scopeStack.isEmpty) return;
    final current = _scopeStack.removeLast();
    if (flush) {
      for (final entry in current) {
        _emit(entry);
      }
    }
  }

  /// Flushes all logs within the current scope without ending it.
  /// Logs remain in the current scope after emitting? No: they are cleared
  /// to avoid duplicate emission on subsequent flushAll/endScope.
  static void flushAll() {
    if (_scopeStack.isEmpty) return;
    final current = _scopeStack.last;
    for (final entry in current) {
      _emit(entry);
    }
    current.clear();
  }

  /// Updates the buffer with a new log entry (overwrites previous entry)
  ///
  /// [logEntry] - The log entry to store in the buffer
  static void updateLog(LogEntry logEntry) {
    if (inScope) {
      _scopeStack.last.add(logEntry);
    } else {
      _logEntry = logEntry;
    }
  }

  /// Flushes the buffered log entry to console output
  ///
  /// Outputs the most recent log entry based on its type and level.
  /// Skips empty messages to avoid unnecessary console output.
  static void flush() {
    if (inScope) {
      // In scope mode, defer emission until flushAll/endScope
      return;
    }

    final message = _logEntry.message ?? '';

    if (message.isEmpty) {
      return;
    }

    _emit(_logEntry);
  }

  /// Clears the buffer by resetting to default LogEntry
  ///
  /// Useful for cleanup or when you want to ensure no pending logs remain.
  static void clear() {
    if (inScope) {
      _scopeStack.last.clear();
    } else {
      _logEntry = LogEntry();
    }
  }

  /// Emits a single log entry immediately using developer.log
  static void _emit(LogEntry entry) {
    switch (entry.type) {
      case LogType.resultSuccess:
        developer.log(entry.message ?? '', level: entry.level ?? 800);
        break;
      case LogType.resultError:
        developer.log(entry.message ?? '', level: entry.level ?? 1000);
        break;
      case LogType.responseSuccess:
        developer.log(entry.message ?? '', level: entry.level ?? 800);
        break;
      case LogType.responseError:
        developer.log(entry.message ?? '', level: entry.level ?? 1000);
        break;
      default:
        break;
    }
  }
}
