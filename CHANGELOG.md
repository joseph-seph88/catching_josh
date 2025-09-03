# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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