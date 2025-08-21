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
final result = josh(() => riskyOperation());
final data = await joshAsync(() async => await api.getData());
joshVoid(() => storage.save(key, value));
```

## Usage Guide

### 1. Synchronous Operations
```dart
// Handle sync operations with error logging
final user = josh(() => parseUser(jsonString));
final data = josh(() => complexCalculation());
```

### 2. Asynchronous Operations
```dart
// Handle async operations with error logging
final posts = await jsAsync(() async => await api.getPosts());
final user = await jsAsync(() async => await api.getUser(id));
```

### 3. Void Operations
```dart
// Handle void operations with error logging
jsVoid(() => storage.saveData('key', 'value'));
jsVoid(() => cache.clear());
```

### 4. Error Handling Options

| Option | Description | Behavior |
|--------|-------------|----------|
| `'null'` (default) | Log error and return null | Safe fallback |
| `'throw'` | Log error and throw original error | Re-throw for handling |
| `'rethrow'` | Log error and rethrow (preserves stack) | Better debugging |
| `'exception'` | Log error and throw new Exception | Custom error type |

### 5. With Context
```dart
// Add context for better debugging
final result = josh(
  () => complexOperation(),
  context: 'User authentication process',
);

final data = await jsAsync(
  () async => await api.getData(),
  context: 'Fetching user posts',
);
```

## Examples

### Basic Error Handling
```dart
// Default behavior: log error and return null
final data1 = josh(() => riskyOperation());

// Log error and throw
final data2 = josh(() => riskyOperation(), returnType: 'throw');

// Log error and rethrow (preserves stack trace)
final data3 = josh(() => riskyOperation(), returnType: 'rethrow');
```

### Real-world Scenarios
```dart
// API calls with error handling
final user = await jsAsync(
  () async => await api.getUser(id),
  context: 'Fetching user data',
);

// JSON parsing with error handling
final data = josh(
  () => jsonDecode(jsonString),
  context: 'Parsing API response',
);

// Local storage operations
jsVoid(
  () => storage.saveData('user_pref', userData),
  context: 'Saving user preferences',
);
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

