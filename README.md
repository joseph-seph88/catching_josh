# catching_josh

**Author:** Joseph88
**Email:** pathetic.sim@gmail.com (Feedback welcome)
**Version:** 1.2.4
**License:** MIT
**Git:** https://github.com/joseph-seph88/catching_josh

> Simple error handling with automatic logging. Focus on business logic, not error handling.

[![pub package](https://img.shields.io/pub/v/catching_josh.svg)](https://pub.dev/packages/catching_josh)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

---

## Why catching_josh?

**Before:**
```dart
Future<String> fetchData() async {
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      debugPrint('HTTP ${response.statusCode} Success: ${response.body}');
      return response.body.toString();
    } else {
      debugPrint('HTTP Error: ${response.statusCode} - ${response.reasonPhrase}');
      return 'Error: ${response.reasonPhrase}';
    }
  } catch (e) {
    debugPrint('Exception: $e');
    return 'Exception: $e';
  }
}
```

**After:**
```dart
Future<String> fetchData() async {
  final response = await joshReq(() => http.get(Uri.parse(url)));
  return response.data?.toString() ?? 'No data';
}
```

---

## Usage

### Basic Examples

```dart
// Sync operation
final result = joshSync(() => parseJson(jsonString));

// Async operation
final user = await joshAsync(() async => api.getUser(id));

// HTTP request
final response = await joshReq(() => http.get(url));
```

### With Logging & Mock Data

```dart
final result = await joshAsync(
  () async => api.getUser(id),
  logTitle: 'Get-User',
  showErrorLog: true,
  mockResultOnCatch: {'id': 1, 'name': 'Mock User'},
);
```

### Batch Logging

```dart
JoshLogBuffer.beginScope();
// ... multiple operations that generate logs
JoshLogBuffer.flushAll();  // Print all logs at once
JoshLogBuffer.endScope();
```

---

## Core Functions

| Function | Purpose | Return Type |
|----------|---------|-------------|
| `joshSync<T>()` | Sync operations | `StandardResult` |
| `joshAsync<T>()` | Async operations | `Future<StandardResult>` |
| `joshReq<T>()` | HTTP requests | `Future<StandardResponse>` |

## Return Types

```dart
class StandardResult {
  final Object? data;
  final String? dataType;
  final String? errorMessage;
  final bool? isSuccess;
}

class StandardResponse {
  final int? statusCode;
  final String? statusMessage;
  final dynamic data;
  final String? dataType;
  final bool? isSuccess;
}
```

## Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `function` | `Function` | Function to execute |
| `logTitle` | `String?` | Title for log messages |
| `errorMessage` | `String?` | Custom error message |
| `showSuccessLog` | `bool` | Log success (default: false) |
| `showErrorLog` | `bool` | Log errors (default: false) |
| `mockResultOnCatch` | `dynamic` | Mock data for testing |
| `rethrowOnError` | `bool` | Rethrow exceptions (default: false) |
| `attachOriginalErrorMessage` | `bool` | Include original error (default: false) |

---

## License

MIT License - see [LICENSE](LICENSE) file for details.
