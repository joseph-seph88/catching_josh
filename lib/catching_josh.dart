/// CatchingJosh - A Flutter package for elegant error handling and logging
///
/// This package provides three core functions for handling errors gracefully:
/// - [joshSync]: For synchronous operations
/// - [joshAsync]: For asynchronous operations
/// - [joshReq]: For HTTP/network requests
///
/// Features include clean error logging, customizable error handling,
/// and automatic response validation for network requests.
library;

// Core Functions
export 'src/core/josh_core.dart';

// Error Handling Types
export 'src/core/error_handle_type.dart';

// Logger
export 'src/logger/josh_logger.dart';

// Exceptions
export 'src/logger/exceptions/josh_exception.dart';

// Utility Classes
export 'src/logger/utils/log_formatter.dart';
export 'src/logger/utils/response_formatter.dart';
export 'src/logger/utils/response_validator.dart';
export 'src/logger/utils/error_extractor.dart';
export 'src/logger/utils/response_extractor.dart';
