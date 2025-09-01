/// CatchingJosh - A Flutter package for elegant error handling and logging
///
/// This package provides three core functions for handling errors gracefully:
/// - [joshSync]: For synchronous operations (file I/O, database operations)
/// - [joshAsync]: For asynchronous operations (file I/O, database operations, service calls)
/// - [joshReq]: For HTTP/network requests with standardized response handling
///
/// Features include clean error logging, customizable error handling,
/// and automatic response validation for network requests.
library;

// Core Functions
export 'src/core/josh_core.dart';

// Handlers
export 'src/handlers/response_handler.dart';
export 'src/handlers/result_handler.dart';

// Models
export 'src/models/standard_response.dart';
export 'src/models/standard_result.dart';

// Logger
export 'src/logger/josh_logger.dart';

// Utility Classes
export 'src/logger/utils/log_formatter.dart';
export 'src/logger/utils/response_type_checker.dart';
export 'src/logger/utils/error_extractor.dart';
