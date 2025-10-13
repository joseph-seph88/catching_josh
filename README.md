# catching_josh

**Author:** Joseph88  
**Version:** 1.2.3
**License:** MIT  
**Git:** https://github.com/joseph-seph88/catching_josh

> **Simple error handling with automatic logging** - Focus on business logic, not error handling.

[![pub package](https://img.shields.io/pub/v/catching_josh.svg)](https://pub.dev/packages/catching_josh)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

---

## How To Use

### Core Methods
These are the main functions for error handling and standardized results:

```dart
// Synchronous operation
final result = joshSync(() => parseJson(jsonString));

// Synchronous with logging and mock
final result = joshSync(
  () => parseJson(jsonString),
  logTitle: 'Time-Parse',
  showErrorLog: true,
  mockResultOnCatch: {
    'time': DateTime.now().toIso8601String(),
  },
);

// Asynchronous operation
final user = await joshAsync(() async => api.getUser(id));

// Asynchronous with logging and mock
final user = await joshAsync(
  () async => api.getUser(id),
  logTitle: 'Get-User-Info',
  showErrorLog: true,
  mockResultOnCatch: {
    'id': 1,
    'name': 'Mock User',
    'email': 'mock@example.com',
  },
);

// Advanced: propagate original error message or rethrow
final result = await joshAsync(
  () async => riskyAsync(),
  attachOriginalErrorMessage: true,
);

// Advanced: rethrow to let upper level handle exceptions
final result2 = await joshAsync(
  () async => riskyAsync(),
  rethrowOnError: true,
);

// HTTP request
final response = await joshReq(() async => http.get(url));

final response = await joshReq(
  () async => http.get(url),
  mockResponseOnCatch: { 
    'id': 1 , 
    'name': 'Mocked Josh', 
    'email': 'mocked@example.com'
  },
);

// Pass-through: if inner already returns StandardResponse, it's returned as-is
final response2 = await joshReq(() async => await joshReq(() async => http.get(url)));
```


### Logging Features
Flexible logging for debugging, monitoring, and batch output:

```dart
// Single line error log
JoshLogger.singleLogLine('Something went wrong');

// Scoped/Batch Logging
// All logs generated after beginScope() are collected and not printed immediately.
JoshLogBuffer.beginScope();

// ...perform various operations (joshAsync, joshReq, etc.) that generate logs...

// Print all accumulated logs at once, in order
JoshLogBuffer.flushAll();

// End the scope. If flushAll() was not called, endScope() will print remaining logs.
// Use endScope(flush: false) to discard all collected logs without printing.
JoshLogBuffer.endScope();
```


## Core Functions

| Function | Purpose | Return Type |
|----------|---------|-------------|
| `joshSync<T>()` | Sync operations | `StandardResult` |
| `joshAsync<T>()` | Async operations | `Future<StandardResult>` |
| `joshReq<T>()` | HTTP requests | `Future<StandardResponse>` |

## Return Types

```dart
class StandardResult {
  final Object? data;           // Result data
  final String? dataType;       // Data type
  final String? errorMessage;   // Error message
  final bool? isSuccess;        // Success status
}

class StandardResponse {
  final int? statusCode;        // HTTP status code
  final String? statusMessage;  // HTTP status message
  final dynamic data;           // Response data
  final String? dataType;       // Data type
  final bool? isSuccess;        // Success status
}
```

## Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `function` | `Function` | ✅ | Function to execute |
| `logTitle` | `String?` | ❌ | Title for log messages |
| `errorMessage` | `String?` | ❌ | Custom error message |
| `showSuccessLog` | `bool` | ❌ | Log success (default: false) |
| `showErrorLog` | `bool` | ❌ | Log errors (default: false) |
| `mockResponseOnCatch` | `dynamic` | ❌ | Mock data for testing (joshReq only) |
| `rethrowOnError` | `bool` | ❌ | Rethrow caught exceptions to caller (default: false) |
| `attachOriginalErrorMessage` | `bool` | ❌ | Put original exception message into result/response when no custom errorMessage/statusMessage provided (default: false) |

### Pass-through behavior (chaining)

- If the inner function already returns `StandardResult` (for `joshSync`/`joshAsync`), the value is returned as-is without double-wrapping.
- If the inner function already returns `StandardResponse` (for `joshReq`), the value is returned as-is.
- This prevents success misclassification and preserves the inner isSuccess/error fields when chaining calls.

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `ENVIRONMENT` | Environment mode (dev/prod/production) | dev |
| `JOSH_LOGGER_MAX_CACHE_SIZE` | Log formatting cache size | 1000 |

```

## License

MIT License - see [LICENSE](LICENSE) file for details.