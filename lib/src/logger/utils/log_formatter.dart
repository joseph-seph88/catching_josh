/// Utility class for formatting log output with beautiful box design
/// Provides methods to create formatted log boxes with consistent styling
class LogFormatter {
  /// Fixed box width for consistent log formatting
  static const int _boxWidth = 80;

  /// Creates the top line of a log box with title
  ///
  /// [title] - The title to display in the box header
  /// Returns a formatted string representing the top border of the log box
  static String createTopLine(String title) {
    final titlePart = '┌─ [$title] ';
    final line = '─' * (_boxWidth - titlePart.length + 1);
    return '$titlePart$line┐';
  }

  /// Creates the bottom line of a log box
  ///
  /// Returns a formatted string representing the bottom border of the log box
  static String createBottomLine() {
    return '└${'─' * (_boxWidth)}┘';
  }

  /// Creates a content line within the log box
  ///
  /// [key] - The label/key for the content
  /// [value] - The value to display
  /// Returns a formatted string representing a line of content with proper padding
  static String createContentLine(String key, dynamic value) {
    final content = '$key:: $value';
    final remainingWidth = _boxWidth - content.length - 2;
    final padding = ' ' * remainingWidth;
    return '│ $content$padding │';
  }
}
