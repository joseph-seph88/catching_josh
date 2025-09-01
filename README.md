# catching_josh

**Author:** Joseph88  
**Version:** 1.2.0  
**License:** MIT
**Git** https://github.com/joseph-seph88/catching_josh

> **Core Value**: Purpose-specific method separation, standardized return value modeling, and automatic logging processing to help developers focus on business logic.

[![pub package](https://img.shields.io/pub/v/catching_josh.svg)](https://pub.dev/packages/catching_josh)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

---

## 🎯 **Core Value**

### 1. **Purpose-Specific Method Separation**
- `joshSync()`: Synchronous operations (file I/O, data parsing, calculations)
- `joshAsync()`: Asynchronous operations (API calls, database operations)
- `joshReq()`: HTTP requests (network communication)

### 2. **Standardized Return Value Modeling**
- `StandardResult`: Consistent result structure for sync/async operations
- `StandardResponse`: Standardized structure for HTTP responses
- Always predictable return values for safe code writing

### 3. **Automatic Logging Processing**
- Automatic clean log output when errors occur
- Optional success logging for debugging
- Production-safe debug mode logging

---

## Installation

```yaml
dependencies:
  catching_josh: ^1.2.0
```

## Quick Start

```dart
import 'package:catching_josh/catching_josh.dart';

// Purpose-specific method separation for intuitive usage
final data = joshSync(() => parseJson(jsonString));           // Sync operation
final user = await joshAsync(() async => api.getUser(id));   // Async operation
final response = await joshReq(() async => http.get(url));   // HTTP request
```

## Usage Guide

### 1. Synchronous Operations (`joshSync`) - Data parsing, calculations, etc.
```dart
// JSON parsing
final user = joshSync(
  () => jsonDecode(jsonString),
  logTitle: 'JSON Parsing',
  errorMessage: 'Invalid JSON format',
);

// Complex calculations
final result = joshSync(
  () => complexCalculation(),
  logTitle: 'Data Calculation',
  showSuccessLog: true,
);
```

### 2. Asynchronous Operations (`joshAsync`) - API calls, file operations, etc.
```dart
// API calls
final posts = await joshAsync(
  () async => await api.getPosts(),
  logTitle: 'Fetch Posts',
  showSuccessLog: true,
);

// File reading
final content = await joshAsync(
  () async => await File('data.txt').readAsString(),
  logTitle: 'File Reading',
);
```

### 3. HTTP Requests (`joshReq`) - Network communication
```dart
// HTTP GET requests
final response = await joshReq(() async => await http.get(url));

// Dio client usage
final dioResponse = await joshReq(() async => await dio.get(url));
```

## 📊 **Standardized Return Value Structure**

### StandardResult (Sync/Async Operations)
```dart
class StandardResult {
  final Object? data;           // Actual result data
  final String? dataType;       // Data type information
  final String? errorMessage;   // Error message if failed
}
```

### StandardResponse (HTTP Requests)
```dart
class StandardResponse {
  final int? statusCode;        // HTTP status code
  final String? statusMessage; // HTTP status message
  final dynamic data;          // Response data
  final String? dataType;      // Data type information
}
```

## 🔍 **Automatic Logging System**

### Error Logging (Automatic)
```dart
// Automatic clean box-formatted log output when errors occur
final result = joshSync(() => riskyOperation());
// ┌─ [Operation Error Summary] ──────────────────────────────┐
// │ Error: FormatException: Invalid JSON format              │
// │ StackTrace: main.dart:25 → parseJson() → jsonDecode()    │
// └──────────────────────────────────────────────────────────┘
```

### Success Logging (Optional)
```dart
final result = joshSync(
  () => successfulOperation(),
  logTitle: 'Data Processing',
  showSuccessLog: true,  // Enable success logging
);
// ┌─ [Data Processing Success Summary] ──────────────────────┐
// │ ResultData: {name: "John", age: 30}                      │
// │ ResultDataType: Map<String, dynamic>                     │
// └──────────────────────────────────────────────────────────┘
```

## Examples

### Real-World Scenarios

```dart
// 1. API data fetching and parsing
final apiResponse = await joshAsync(
  () async => await api.getUserData(userId),
  logTitle: 'User Data Fetch',
  showSuccessLog: true,
);

if (apiResponse.data != null) {
  final userData = joshSync(
    () => User.fromJson(apiResponse.data),
    logTitle: 'User Data Parsing',
    errorMessage: 'Failed to parse user data',
  );
}

// 2. HTTP request handling
final httpResponse = await joshReq(
  () async => await http.get(Uri.parse('https://api.example.com/data')),
);

// 3. File system operations
final fileContent = await joshAsync(
  () async => await File('config.json').readAsString(),
  logTitle: 'Config File Reading',
);
```

### Traditional Approach vs CatchingJosh

```dart
// ❌ Traditional approach (complex and repetitive)
try {
  final response = await http.get(url);
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data;
  } else {
    print('HTTP Error: ${response.statusCode}');
    return null;
  }
} catch (e) {
  print('Error: $e');
  return null;
}

// ✅ CatchingJosh approach (simple and intuitive)
final response = await joshReq(() async => await http.get(url));
return response.data;
```

## API Reference

### Core Functions

| Function | Purpose | Return Type | Use Cases |
|----------|---------|-------------|-----------|
| `joshSync<T>()` | Sync operations | `StandardResult` | Data parsing, calculations, transformations |
| `joshAsync<T>()` | Async operations | `Future<StandardResult>` | API calls, file operations, DB queries |
| `joshReq<T>()` | HTTP requests | `Future<StandardResponse>` | Network communication, external APIs |

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `function` | `Function` | ✅ | Function to execute |
| `logTitle` | `String?` | ❌ | Title for log messages |
| `errorMessage` | `String?` | ❌ | Custom error message |
| `showSuccessLog` | `bool` | ❌ | Whether to log success (default: false) |
| `showErrorLog` | `bool` | ❌ | Whether to log errors (default: false) |

## Example App

Check out the interactive Flutter app in the `/example` folder to test all features in action.

## Features

### 🎯 **Core Features**
- **Purpose-Specific Method Separation**: Clear role division with `joshSync`, `joshAsync`, `joshReq`
- **Standardized Return Values**: Consistent data structure with `StandardResult`/`StandardResponse`
- **Automatic Logging Processing**: Automatic clean log output when errors occur

### 🛡️ **Safety**
- **Exception-Free Execution**: Always returns result objects for safe code
- **Type Safety**: Full Dart type safety support
- **Production Safe**: Log output only in debug mode

### ⚡ **Performance**
- **Cache System**: Log formatting performance optimization
- **Memory Monitoring**: Accurate memory usage calculation
- **Environment Variable Configuration**: Cache size adjustment with `JOSH_LOGGER_MAX_CACHE_SIZE`

### 🔧 **Developer Experience**
- **Zero Dependencies**: No external package dependencies
- **Intuitive API**: Ready to use without complex configuration
- **Consistent Pattern**: All functions follow the same usage pattern

## Environment Variables

| Variable | Description | Default | Usage |
|----------|-------------|---------|-------|
| `JOSH_LOGGER_MAX_CACHE_SIZE` | Cache size for log formatting | 1000 | `flutter run --dart-define=JOSH_LOGGER_MAX_CACHE_SIZE=2000` |

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

