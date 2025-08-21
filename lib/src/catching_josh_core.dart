import 'logger/catching_josh_logger.dart';

/// JS function for sync operations
T? josh<T>(
  T Function() function, {
  String returnType = 'null', // 'null', 'throw', 'rethrow', 'exception'
  String? context,
}) {
  try {
    return function();
  } catch (error, stackTrace) {
    if (returnType == 'rethrow') {
      rethrow;
    } else {
      return _handleError<T>(error, stackTrace, returnType, context);
    }
  }
}

/// JS function for async operations
Future<T?> joshAsync<T>(
  Future<T> Function() function, {
  String returnType = 'null', // 'null', 'throw', 'rethrow', 'exception'
  String? context,
}) async {
  try {
    return await function();
  } catch (error, stackTrace) {
    if (returnType == 'rethrow') {
      rethrow;
    } else {
      return _handleError<T>(error, stackTrace, returnType, context);
    }
  }
}

/// JS function for void operations
void joshVoid(
  void Function() function, {
  String returnType = 'null', // 'null', 'throw', 'rethrow', 'exception'
  String? context,
}) {
  try {
    function();
  } catch (error, stackTrace) {
    if (returnType == 'rethrow') {
      rethrow;
    } else {
      _handleErrorForVoid(error, stackTrace, returnType, context);
    }
  }
}

/// Handle error based on returnType
T? _handleError<T>(
  Object error,
  StackTrace? stackTrace,
  String returnType,
  String? context,
) {
  switch (returnType) {
    case 'null':
      CatchingJoshLogger.logError(error, stackTrace, context: context);
      return null;

    case 'throw':
      CatchingJoshLogger.logError(error, stackTrace, context: context);
      throw error;

    case 'exception':
      CatchingJoshLogger.logError(error, stackTrace, context: context);
      throw Exception('JS Error: $error');

    default:
      CatchingJoshLogger.logError(error, stackTrace, context: context);
      return null;
  }
}

/// Handle error for void functions
void _handleErrorForVoid(
  Object error,
  StackTrace? stackTrace,
  String returnType,
  String? context,
) {
  switch (returnType) {
    case 'null':
      CatchingJoshLogger.logError(error, stackTrace, context: context);
      break;

    case 'throw':
      CatchingJoshLogger.logError(error, stackTrace, context: context);
      throw error;

    case 'exception':
      CatchingJoshLogger.logError(error, stackTrace, context: context);
      throw Exception('[JS Error]:: $error');

    default:
      CatchingJoshLogger.logError(error, stackTrace, context: context);
      break;
  }
}
