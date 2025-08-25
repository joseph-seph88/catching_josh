# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- Performance optimizations
- Additional utility functions
- Extended documentation and examples

## [1.0.0+1] - 2025-08-25

### Added
- Initial release of CatchingJosh package
- Core error handling functions: `joshSync()`, `joshAsync()`, `joshReq()`
- Flexible error handling with `ErrorHandleType` enum
- Beautiful formatted error logging system
- HTTP response validation for network requests
- Comprehensive test coverage for all core functions

### Core Features
- **`joshSync<T>()`** - Synchronous error handling with logging
- **`joshAsync<T>()`** - Asynchronous error handling for Future operations
- **`joshReq<T>()** - HTTP/network request handling with response validation
- **Error handling types**: returnNull, rethrowError, throwError
- **Customizable logging**: success/error log control
- **Message titles and custom error messages**

### Technical Details
- Dart/Flutter package with zero external dependencies
- Beautiful box-formatted logging output
- Stack trace extraction and formatting
- HTTP response status validation
- MIT License
