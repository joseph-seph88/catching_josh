# catching_josh

**Author:** Joseph88  
**Version:** 1.2.1  
**License:** MIT  
**Git:** https://github.com/joseph-seph88/catching_josh

> **Simple error handling with automatic logging** - Focus on business logic, not error handling.

[![pub package](https://img.shields.io/pub/v/catching_josh.svg)](https://pub.dev/packages/catching_josh)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

---

## Installation

```yaml
dependencies:
  catching_josh: ^1.2.1
```

## Quick Start

```dart
import 'package:catching_josh/catching_josh.dart';

// Sync operations
final result = joshSync(() => parseJson(jsonString));

// Async operations  
final user = await joshAsync(() async => api.getUser(id));

// HTTP requests
final response = await joshReq(() async => http.get(url));
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

## Examples

### Basic Usage
```dart
// Sync operation
final result = joshSync(
  () => jsonDecode(jsonString),
  logTitle: 'JSON Parsing',
  showErrorLog: true,
);

if (result.isSuccess == true) {
  print('Data: ${result.data}');
}
```

### HTTP Request
```dart
final response = await joshReq(
  () async => http.get(Uri.parse('https://api.example.com/data')),
);

if (response.isSuccess == true) {
  print('Status: ${response.statusCode}');
  print('Data: ${response.data}');
}
```

### Async Operation
```dart
final user = await joshAsync(
  () async => await api.getUser(userId),
  logTitle: 'User Fetch',
  showSuccessLog: true,
  showErrorLog: true,
);

if (user.isSuccess == true) {
  // Use user.data
}
```

## Features

- **🎯 Purpose-specific methods**: `joshSync`, `joshAsync`, `joshReq`
- **📊 Standardized returns**: Always predictable result structure
- **🔍 Automatic logging**: Clean formatted logs with stack traces
- **⚡ Dual logging system**: User-facing + Internal batch logging
- **🛡️ Production-safe**: Success logs disabled in production
- **🚀 Zero dependencies**: No external packages required

## Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `function` | `Function` | ✅ | Function to execute |
| `logTitle` | `String?` | ❌ | Title for log messages |
| `errorMessage` | `String?` | ❌ | Custom error message |
| `showSuccessLog` | `bool` | ❌ | Log success (default: false) |
| `showErrorLog` | `bool` | ❌ | Log errors (default: false) |

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `JOSH_LOGGER_MAX_CACHE_SIZE` | Log formatting cache size | 1000 |

## License

MIT License - see [LICENSE](LICENSE) file for details.