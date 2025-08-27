/// Utility class for formatting log output with clean box design
/// Provides methods to create formatted log boxes with consistent styling
class LogFormatter {
  static const int _defaultMaxCacheSize = 1000;
  static const int _maxCacheSize = int.fromEnvironment(
    'JOSH_LOGGER_MAX_CACHE_SIZE',
    defaultValue: _defaultMaxCacheSize,
  );

  static const int _boxWidth = 80;
  
  static final Map<String, String> _cachedTopLines = {};
  static final Map<String, String> _cachedContentLines = {};
  static final String _cachedBottomLine = _createBottomLine();

  static final List<String> _dashLines = List.generate(
    100,
    (i) => '─' * i,
    growable: false,
  );

  /// Creates the top line of a log box with title
  ///
  /// [title] - The title to display in the box header
  /// Returns a formatted string representing the top border of the log box
  static String createTopLine(String title) {
    final cached = _cachedTopLines[title];
    if (cached != null) return cached;

    final result = _calculateTopLine(title);
    _cachedTopLines[title] = result;

    if (_cachedTopLines.length > _maxCacheSize) {
      _cleanupCache();
    }

    return result;
  }

  /// Creates the bottom line of a log box
  ///
  /// Returns a formatted string representing the bottom border of the log box
  static String createBottomLine() {
    return _cachedBottomLine;
  }

  /// Creates a content line within the log box
  ///
  /// [key] - The label/key for the content
  /// [value] - The value to display
  /// Returns a formatted string representing a line of content with proper padding
  static String createContentLine(String key, dynamic value) {
    final cacheKey = '$key::$value';

    final cached = _cachedContentLines[cacheKey];
    if (cached != null) return cached;

    final result = _calculateContentLine(key, value);
    _cachedContentLines[cacheKey] = result;

    if (_cachedContentLines.length > _maxCacheSize) {
      _cleanupContentCache();
    }

    return result;
  }

  static String _calculateTopLine(String title) {
    final titlePart = '┌─ [$title] ';
    final remainingWidth = _boxWidth - titlePart.length + 1;

    String dashLine;
    if (remainingWidth < _dashLines.length) {
      dashLine = _dashLines[remainingWidth];
    } else {
      dashLine = '─' * remainingWidth;
    }

    return '$titlePart$dashLine┐';
  }

  static String _calculateContentLine(String key, dynamic value) {
    final content = '$key:: $value';
    final remainingWidth = _boxWidth - content.length - 2;
    final padding = ' ' * remainingWidth;
    return '│ $content$padding │';
  }

  static String _createBottomLine() {
    return '└${'─' * (_boxWidth)}┘';
  }

  static void _cleanupCache() {
    final keysToRemove =
        _cachedTopLines.keys.take(_cachedTopLines.length ~/ 2).toList();
    for (final key in keysToRemove) {
      _cachedTopLines.remove(key);
    }
  }

  static void _cleanupContentCache() {
    final keysToRemove =
        _cachedContentLines.keys.take(_cachedContentLines.length ~/ 2).toList();
    for (final key in keysToRemove) {
      _cachedContentLines.remove(key);
    }
  }

  static int get topLineCacheSize => _cachedTopLines.length;
  static int get contentLineCacheSize => _cachedContentLines.length;
  static int get maxCacheSize => _maxCacheSize;

  static void clearAllCaches() {
    _cachedTopLines.clear();
    _cachedContentLines.clear();
  }

  /// Calculates accurate memory usage in bytes
  /// Uses UTF-8 encoding for accurate byte calculation
  static int get estimatedMemoryUsage {
    int totalBytes = 0;

    for (final entry in _cachedTopLines.entries) {
      totalBytes += _calculateStringBytes(entry.key);
      totalBytes += _calculateStringBytes(entry.value);
    }

    for (final entry in _cachedContentLines.entries) {
      totalBytes += _calculateStringBytes(entry.key);
      totalBytes += _calculateStringBytes(entry.value);
    }

    return totalBytes;
  }

  /// Calculates the actual byte size of a string using UTF-8 encoding
  /// More accurate than assuming 2 bytes per character
  static int _calculateStringBytes(String str) {
    try {
      return str.codeUnits.fold<int>(0, (total, codeUnit) {
        if (codeUnit < 0x80) {
          return total + 1; // ASCII: 1 byte
        } else if (codeUnit < 0x800) {
          return total + 2; // 2-byte UTF-8
        } else if (codeUnit < 0x10000) {
          return total + 3; // 3-byte UTF-8
        } else {
          return total + 4; // 4-byte UTF-8 (surrogate pairs)
        }
      });
    } catch (e) {
      return str.length * 2;
    }
  }

  /// Sets custom cache size limit
  /// Useful for memory-constrained environments
  static void setMaxCacheSize(int newSize) {
    if (newSize > 0) {
      if (newSize < _cachedTopLines.length) {
        _cleanupCache();
      }
      if (newSize < _cachedContentLines.length) {
        _cleanupContentCache();
      }
    }
  }

  /// Gets cache statistics for monitoring
  static Map<String, dynamic> get cacheStats {
    return {
      'topLineCacheSize': _cachedTopLines.length,
      'contentLineCacheSize': _cachedContentLines.length,
      'maxCacheSize': _maxCacheSize,
      'estimatedMemoryUsage': estimatedMemoryUsage,
      'memoryUsageKB': (estimatedMemoryUsage / 1024).toStringAsFixed(2),
    };
  }
}
