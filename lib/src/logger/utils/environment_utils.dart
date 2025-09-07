/// Environment utility functions for CatchingJosh package
/// Provides common environment detection and configuration utilities
/// Centralized environment management to avoid code duplication across logging classes
class EnvironmentUtils {
  /// Checks if the current environment is production
  ///
  /// Returns true if ENVIRONMENT is set to 'prod' or 'production'
  /// Returns false for all other values (defaults to 'dev')
  static bool get isProduction {
    const environment =
        String.fromEnvironment('ENVIRONMENT', defaultValue: 'dev');
    return environment == 'prod' || environment == 'production';
  }

  /// Checks if the current environment is development
  ///
  /// Returns true if ENVIRONMENT is not set to 'prod' or 'production'
  /// Returns false for production environments
  static bool get isDevelopment {
    return !isProduction;
  }

  /// Gets the current environment string
  ///
  /// Returns the value of ENVIRONMENT environment variable
  /// Defaults to 'dev' if not set
  static String get currentEnvironment {
    return const String.fromEnvironment('ENVIRONMENT', defaultValue: 'dev');
  }
}
