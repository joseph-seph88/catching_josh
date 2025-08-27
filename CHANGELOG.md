# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- Performance optimizations
- Additional utility functions
- Extended documentation and examples

## [1.1.0] - 2025-08-28

### Added
- **Enhanced Logging System**: Improved ResponseExtractor with debug-mode only logging using `developer.log`
- **Configurable Cache Management**: Environment variable-based cache size configuration (`JOSH_LOGGER_MAX_CACHE_SIZE`)
- **Accurate Memory Usage Calculation**: UTF-8 encoding based memory usage calculation for better monitoring
- **Dynamic Cache Size Adjustment**: Runtime cache size adjustment capabilities
- **Cache Statistics Monitoring**: Comprehensive cache statistics and performance monitoring

### Improved
- **ResponseExtractor Error Handling**: Better error logging with consistent message format and English localization
- **LogFormatter Performance**: Enhanced caching system with configurable limits and memory optimization
- **Debug Mode Logging**: Production-safe logging using `assert()` blocks for development-only output
- **Code Maintainability**: Unified logging approach with `_extractDebugLog()` helper method

### Technical Enhancements
- **Environment Variable Support**: `JOSH_LOGGER_MAX_CACHE_SIZE` for flexible cache configuration
- **Memory Usage Accuracy**: Proper UTF-8 byte calculation instead of character count assumptions
- **Runtime Cache Management**: `setMaxCacheSize()` method for dynamic cache size adjustment
- **Performance Monitoring**: `cacheStats` getter for comprehensive cache performance insights

## [1.0.0+1] - 2025-08-25

### Added
- Initial release of CatchingJosh package
- Core error handling functions: `joshSync()`, `joshAsync()`, `joshReq()`
- Flexible error handling with `ErrorHandleType` enum
- clean formatted error logging system
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
- clean box-formatted logging output
- Stack trace extraction and formatting
- HTTP response status validation
- MIT License
