# catching_josh

**Author:** Joseph88  
**Version:** 1.0.0  
**License:** MIT
**Git** https://github.com/joseph-seph88/catching_josh

> A package developed to minimize repetitive use of try-catch statements, designed with the goal of simple and intuitive usability.

[![pub package](https://img.shields.io/pub/v/catching_josh.svg)](https://pub.dev/packages/catching_josh)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

---

## Installation

```yaml
dependencies:
  catching_josh: ^1.0.0
```

## Quick Start

```dart
import 'package:catching_josh/catching_josh.dart';

// Basic usage examples
final response = joshSync(() => riskyOperation());
final response = await joshAsync(() async => await api.getData());
final response = await joshReq(() async => await http.get(url));
```

## Usage Guide

### 1. Synchronous Operations (`joshSync`)
```dart
// Handle sync operations with error logging
final user = joshSync(() => parseUser(jsonString));
final data = joshSync(() => complexCalculation());
final result = joshSync(
  () => riskyOperation(),
  messageTitle: 'User parsing',
  errorMessage: 'Failed to parse user data',
);
```

### 2. Asynchronous Operations (`joshAsync`)
```dart
// Handle async operations with error logging
final posts = await joshAsync(() async => await api.getPosts());
final user = await joshAsync(
  () async => await api.getUser(id),
  messageTitle: 'Fetch user data',
  errorHandleType: ErrorHandleType.returnNull,
);
```

### 3. HTTP/Network Requests (`joshReq`)
```dart
// Handle HTTP requests with automatic response validation
final response = await joshReq(() async => await http.get(url));
final dioResponse = await joshReq(
  () async => await dio.get(url),
  messageTitle: 'API call',
  errorHandleType: ErrorHandleType.rethrowError,
);
```

### 4. Error Handling Options

| Option | Description | Behavior |
|--------|-------------|----------|
| `ErrorHandleType.returnNull` | Log error and return null | Safe fallback |
| `ErrorHandleType.throwError` | Log error and throw JoshException | Custom error handling |
| `ErrorHandleType.rethrowError` | Log error and rethrow original | Preserves original stack trace |

### 5. Logging Features

#### Success Logging
- Automatic success response logging
- HTTP response status code and data type detection
- Customizable success message titles

#### Error Logging
- Clean box-formatted error logs
- Stack trace extraction and formatting
- Custom error messages and titles
- File and line number information

## Examples

### Basic Error Handling
```dart
// Default behavior: log error and throw JoshException
final data1 = joshSync(() => riskyOperation());

// Log error and return null
final data2 = joshAsync(
  () async => await api.getData(),
  errorHandleType: ErrorHandleType.returnNull,
);

// Log error and rethrow (preserves stack trace)
final data3 = await joshReq(
  () async => await http.get(url),
  errorHandleType: ErrorHandleType.rethrowError,
);
```

### Real-world Scenarios
```dart
// API calls with error handling
final user = await joshAsync(
  () async => await api.getUser(id),
  messageTitle: 'Fetching user data',
  errorHandleType: ErrorHandleType.returnNull,
);

// JSON parsing with error handling
final data = joshSync(
  () => jsonDecode(jsonString),
  messageTitle: 'Parsing API response',
  errorMessage: 'Invalid JSON format',
);

// HTTP requests with validation
final response = await joshReq(
  () async => await http.get(Uri.parse(url)),
  messageTitle: 'Fetching posts',
  showSuccessLog: true,
  showErrorLog: true,
);
```

### Custom Error Messages
```dart
final result = joshSync(
  () => complexOperation(),
  messageTitle: 'Data processing',
  errorMessage: 'Failed to process user data. Please try again.',
);
```

## API Reference

### Core Functions

| Function | Purpose | Return Type | Best For |
|----------|---------|-------------|----------|
| `joshSync<T>()` | Sync operations | `T?` | Data parsing, calculations |
| `joshAsync<T>()` | Async operations | `Future<T?>` | API calls, file operations |
| `joshReq<T>()` | HTTP requests | `Future<T>` | Network calls, external APIs |

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `function` | `Function` | ✅ | The function to execute |
| `errorHandleType` | `ErrorHandleType` | ❌ | Error handling strategy |
| `messageTitle` | `String?` | ❌ | Title for logging messages |
| `errorMessage` | `String?` | ❌ | Custom error message |
| `showSuccessLog` | `bool` | ❌ | Whether to log success (default: true) |
| `showErrorLog` | `bool` | ❌ | Whether to log errors (default: true) |

### ErrorHandleType Enum

```dart
enum ErrorHandleType {
  returnNull('null'),      // Return null on error
  rethrowError('rethrow'), // Rethrow original error
  throwError('throw'),     // Throw JoshException
}
```

## Example App

Check out the comprehensive example in the `/example` folder to see all features in action with an interactive Flutter app.

## Features

- **Clean Error Handling**: Clean formatted error logs
- **Flexible Error Strategies**: Multiple error handling options
- **Automatic Response Validation**: HTTP response status checking
- **Customizable Logging**: Control what gets logged
- **Type Safety**: Full Dart type safety support
- **Zero Dependencies**: No external package dependencies

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

