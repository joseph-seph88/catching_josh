# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial package structure for CatchingJosh
- Core error handling functions: `josh()`, `joshAsync()`, `joshVoid()`
- Flexible error handling with multiple return types (null, throw, rethrow, exception)
- Context-aware error logging system
- Comprehensive test coverage for all core functions
- Logger system for error tracking and debugging

### Core Features
- **`josh<T>()`** - Synchronous error handling with customizable return behavior
- **`joshAsync<T>()`** - Asynchronous error handling for Future operations
- **`joshVoid()`** - Void function error handling
- **Error return types**: null, throw, rethrow, exception
- **Context support** for better error tracking and debugging

### Technical Implementation
- Dart/Flutter package structure
- Error handling utilities for try-catch operations
- Logger integration for error reporting
- Comprehensive unit tests covering all scenarios
- MIT License

## [1.0.0] - Planned Release

### Planned Enhancements
- Enhanced error logging and reporting
- Performance optimizations
- Additional utility functions
- Extended documentation and examples
- Community feedback integration
