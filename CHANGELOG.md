# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.2.4] - 2025-12-24

### Changed
- SDK: `^3.6.0` → `>=3.0.0 <4.0.0` (broader compatibility)
- Flutter: `>=3.16.0` → `>=3.10.0`

### Added
- Test package in dev_dependencies for proper testing infrastructure

### Improved
- README with clearer examples and value proposition
- Code formatting verified


## [1.2.3] - 2025-10-13

### Added
- **Scoped Batch Logging**: `JoshLogBuffer` now supports scoped batch logging with `beginScope`, `endScope`, and `flushAll` for grouped log emission.
- **Pass-Through Logic**: Chained `joshReq`/`joshAsync` calls now support pass-through for `StandardResult`/`StandardResponse` objects.
- **Error Propagation Flags**: Optional `rethrowOnError` and `attachOriginalErrorMessage` flags for fine-grained error handling in core methods.
- **Unit Tests**: Added tests for chaining, pass-through, and scoped logging behaviors.

### Changed
- **Error Propagation**: Improved error and log propagation in chained core calls; more predictable and robust handling.
- **Documentation**: Updated README with new usage examples and logging features.

### Fixed
- **Test Reliability**: Fixed test failures related to pass-through and batch logging edge cases.

## [1.2.2] - 2025-09-07

### Added
- **Environment Utils**: Centralized environment detection with `EnvironmentUtils` class
- **Mock Data Support**: `joshReq` now supports mock data fallback for testing
- **Development-Only Mock**: Mock data only returned in development environments
- **Single Log Line**: `JoshLogger.singleLogLine()` method for simple error message formatting

### Changed
- **Code Refactoring**: Removed duplicate `_isProduction` logic across logging classes
- **Simplified joshReq**: Cleaner error handling with ternary operator
- **Centralized Environment**: All environment checks now use `EnvironmentUtils`

### Improved
- **Code Quality**: Eliminated code duplication and improved maintainability
- **Testing Support**: Better mock data handling for development and testing
- **Documentation**: Updated comments to reflect new architecture

## [1.2.1] - 2025-09-04

### Added
- **Dual Logging System**: `JoshLogger` (user-facing) + `JoshLoggerInternal` (internal batch)
- **Single Log Buffer**: `JoshLogBuffer` for efficient memory usage

### Changed
- **Batch Logging**: All handlers use `JoshLoggerInternal` with Core-controlled flushing
- **Production Optimization**: Success logs disabled in production

### Improved
- **Documentation**: Clear comments explaining dual logging architecture
- **Performance**: Batch logging reduces console output overhead

## [1.2.0] - 2025-09-01

### Changed
- **Simplified API**: Removed complex ErrorHandleType enum and JoshException
- **Streamlined Error Handling**: Always return StandardResult/StandardResponse objects
- **Unified Parameters**: Consistent use of `logTitle` parameter

### Removed
- **ErrorHandleType Enum**: Complex error handling strategies
- **JoshException Class**: Custom exception class
- **Complex Error Logic**: Simplified error handling

## [1.1.0] - 2025-08-28

### Added
- **Enhanced Logging**: Debug-mode only logging with `developer.log`
- **Cache Management**: Environment variable-based cache configuration
- **Memory Monitoring**: Accurate memory usage calculation

### Improved
- **LogFormatter Performance**: Enhanced caching system
- **Error Handling**: Better error logging with consistent format

## [1.0.0+1] - 2025-08-25

### Added
- Initial release of CatchingJosh package
- Core functions: `joshSync()`, `joshAsync()`, `joshReq()`
- Clean formatted error logging system
- HTTP response validation