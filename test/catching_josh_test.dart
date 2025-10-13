import 'package:flutter_test/flutter_test.dart';
import 'package:catching_josh/catching_josh.dart';
import 'package:catching_josh/src/logger/josh_logger_internal.dart';
import 'package:catching_josh/src/logger/josh_log_buffer.dart';
import 'package:catching_josh/src/logger/utils/environment_utils.dart';

void main() {
  group('Josh Functions Tests', () {
    group('joshSync Tests', () {
      test('joshSync - successful sync operation', () {
        final result = joshSync(() => 'success');
        expect(result.data, equals('success'));
        expect(result.dataType, equals('String'));
        expect(result.errorMessage, isNull);
        expect(result.isSuccess, equals(true));
      });

      test('joshSync - sync operation with error', () {
        final result = joshSync(() {
          throw Exception('Test error');
        });
        expect(result.data, isNull);
        expect(result.errorMessage, isNull);
        expect(result.isSuccess, equals(false));
      });

      test('joshSync - with logTitle', () {
        final result = joshSync(
          () => 'success',
          logTitle: 'Test operation',
        );
        expect(result.data, equals('success'));
        expect(result.dataType, equals('String'));
      });

      test('joshSync - with errorMessage', () {
        final result = joshSync(
          () => throw Exception('Test error'),
          errorMessage: 'Custom error message',
        );
        expect(result.data, isNull);
        expect(result.errorMessage, equals('Custom error message'));
        expect(result.isSuccess, equals(false));
      });

      test('joshSync - enable success log', () {
        final result = joshSync(
          () => 'success',
          showSuccessLog: true,
        );
        expect(result.data, equals('success'));
      });

      test('joshSync - enable error log', () {
        final result = joshSync(
          () => throw Exception('Test error'),
          showErrorLog: true,
        );
        expect(result.data, isNull);
        expect(result.errorMessage, isNull);
      });

      test('joshSync - returns mock data in development on error', () {
        final result = joshSync(
          () {
            throw Exception('Sync error');
          },
          mockResultOnCatch: {'mock': 'sync'},
        );
        // In development environment, should return mock data
        expect(result.data, isNotNull);
        expect(result.isSuccess, equals(false));
      });
    });

    group('joshAsync Tests', () {
      test('joshAsync - successful async operation', () async {
        final result = await joshAsync(() async {
          await Future.delayed(Duration(milliseconds: 1));
          return 'async success';
        });
        expect(result.data, equals('async success'));
        expect(result.dataType, equals('String'));
        expect(result.errorMessage, isNull);
      });

      test('joshAsync - async operation with error', () async {
        final result = await joshAsync(() async {
          await Future.delayed(Duration(milliseconds: 1));
          throw Exception('Test async error');
        });
        expect(result.data, isNull);
        expect(result.errorMessage, isNull);
      });

      test('joshAsync - with logTitle and errorMessage', () async {
        final result = await joshAsync(
          () async {
            await Future.delayed(Duration(milliseconds: 1));
            return 'success';
          },
          logTitle: 'Test async operation',
          errorMessage: 'Custom error message',
        );
        expect(result.data, equals('success'));
        expect(result.dataType, equals('String'));
      });

      test('joshAsync - enable success log', () async {
        final result = await joshAsync(
          () async {
            await Future.delayed(Duration(milliseconds: 1));
            return 'success';
          },
          showSuccessLog: true,
        );
        expect(result.data, equals('success'));
      });

      test('joshAsync - enable error log', () async {
        final result = await joshAsync(
          () async {
            await Future.delayed(Duration(milliseconds: 1));
            throw Exception('Test async error');
          },
          showErrorLog: true,
        );
        expect(result.data, isNull);
        expect(result.errorMessage, isNull);
      });

      test('joshAsync - returns mock data in development on error', () async {
        final result = await joshAsync(
          () async {
            await Future.delayed(Duration(milliseconds: 1));
            throw Exception('Async error');
          },
          mockResultOnCatch: {'mock': 'async'},
        );
        // In development environment, should return mock data
        expect(result.data, isNotNull);
        expect(result.isSuccess, equals(false));
      });

      test('joshAsync - pass-through StandardResult from inner call', () async {
        final inner = await joshAsync(() async => 'inner');
        // Now wrap the StandardResult again
        final outer = await joshAsync(() async => inner);
        expect(outer.data, equals('inner'));
        expect(outer.isSuccess, equals(true));
      });

      test('joshAsync - attachOriginalErrorMessage populates errorMessage',
          () async {
        final res = await joshAsync(
          () async {
            throw Exception('Original async error');
          },
          attachOriginalErrorMessage: true,
        );
        expect(res.isSuccess, equals(false));
        expect(res.errorMessage, contains('Original async error'));
      });

      test('joshAsync - rethrowOnError propagates exception', () async {
        expect(
          () => joshAsync(
            () async {
              throw Exception('Rethrow async error');
            },
            rethrowOnError: true,
          ),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('joshReq Tests', () {
      test('joshReq - successful request operation', () async {
        final result = await joshReq(() async {
          await Future.delayed(Duration(milliseconds: 1));
          return 'success data';
        });
        expect(result.data, equals('success data'));
        expect(result.statusMessage, isNotNull);
        expect(result.dataType, equals('String'));
      });

      test('joshReq - request operation with error', () async {
        final result = await joshReq(() async {
          await Future.delayed(Duration(milliseconds: 1));
          throw Exception('Test request error');
        });
        expect(result.statusMessage, equals('Unknown Response Error'));
        expect(result.data, isNull);
      });

      test('joshReq - with mock data in development', () async {
        final result = await joshReq(
          () async {
            await Future.delayed(Duration(milliseconds: 1));
            throw Exception('Test request error');
          },
          mockResponseOnCatch: {'mock': 'data'},
        );
        expect(result.statusMessage, equals('Unknown Response Error'));
        // In development environment, should return mock data
        expect(result.data, isNotNull);
      });

      test('joshReq - null response handling', () async {
        final result = await joshReq(() async {
          await Future.delayed(Duration(milliseconds: 1));
          return null;
        });
        expect(result.statusMessage, equals('Response is Null'));
        expect(result.data, isNull);
      });

      test('joshReq - pass-through StandardResponse from inner call', () async {
        // Inner joshReq returns a successful StandardResponse
        final inner = StandardResponse(
          statusCode: 200,
          statusMessage: 'OK',
          data: 'ok',
          dataType: 'String',
          isSuccess: true,
        );
        final outer = await joshReq(() async => inner);
        expect(outer.data, equals('ok'));
        expect(outer.isSuccess, equals(true));
      });

      test(
          'joshReq - attachOriginalErrorMessage appends error to statusMessage',
          () async {
        final res = await joshReq(
          () async {
            throw Exception('Request exploded');
          },
          attachOriginalErrorMessage: true,
        );
        expect(res.isSuccess, equals(false));
        expect(res.statusMessage, contains('Unknown Response Error'));
        expect(res.statusMessage, contains('Request exploded'));
      });

      test('joshReq - rethrowOnError propagates exception', () async {
        expect(
          () => joshReq(
            () async {
              throw Exception('Rethrow request error');
            },
            rethrowOnError: true,
          ),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Integration Tests', () {
      test('Combined sync and async operations', () async {
        final syncResult = joshSync(() => 'sync success');
        expect(syncResult.data, equals('sync success'));
        expect(syncResult.dataType, equals('String'));

        final asyncResult = await joshAsync(() async {
          await Future.delayed(Duration(milliseconds: 1));
          return 'async success';
        });
        expect(asyncResult.data, equals('async success'));
        expect(asyncResult.dataType, equals('String'));

        final requestResult = await joshReq(() async {
          await Future.delayed(Duration(milliseconds: 1));
          return 'request success';
        });
        expect(requestResult.data, equals('request success'));
      });

      test('Error handling across different functions', () async {
        final syncResult = joshSync(() => throw Exception('Sync error'));
        expect(syncResult.data, isNull);
        expect(syncResult.errorMessage, isNull);

        final asyncResult = await joshAsync(() async {
          await Future.delayed(Duration(milliseconds: 1));
          throw Exception('Async error');
        });
        expect(asyncResult.data, isNull);
        expect(asyncResult.errorMessage, isNull);

        final requestResult = await joshReq(() async {
          await Future.delayed(Duration(milliseconds: 1));
          throw Exception('Request error');
        });
        expect(requestResult.statusMessage, equals('Unknown Response Error'));
        expect(requestResult.data, isNull);
      });
    });

    group('Logging System Tests', () {
      test('JoshLogger - user-facing logging', () {
        // Test that JoshLogger methods can be called without errors
        expect(
            () => JoshLogger.logResultError(
                  error: 'Test error',
                  errorTitle: 'Test',
                  errorMessage: 'Test error message',
                ),
            returnsNormally);
      });

      test('JoshLoggerInternal - internal batch logging', () {
        // Test that JoshLoggerInternal methods can be called without errors
        expect(
            () => JoshLoggerInternal.logResultError(
                  error: 'Test error',
                  errorTitle: 'Test',
                  errorMessage: 'Test error message',
                ),
            returnsNormally);
      });

      test('JoshLogBuffer - buffer operations', () {
        // Test buffer operations
        final logEntry = LogEntry(
          type: LogType.resultSuccess,
          message: 'Test message',
          level: 800,
        );

        expect(() => JoshLogBuffer.updateLog(logEntry), returnsNormally);
        expect(() => JoshLogBuffer.flush(), returnsNormally);
        expect(() => JoshLogBuffer.clear(), returnsNormally);
      });

      test('Dual logging system integration', () {
        // Test that both logging systems work together
        final result = joshSync(
          () => 'test success',
          logTitle: 'Integration Test',
          showSuccessLog: true,
          showErrorLog: true,
        );

        expect(result.isSuccess, equals(true));
        expect(result.data, equals('test success'));
      });

      test('Scoped logging - basic begin/flushAll/end', () {
        // Begin scope and accumulate logs
        JoshLogBuffer.beginScope();
        expect(JoshLogBuffer.inScope, isTrue);

        // Add multiple entries
        JoshLogBuffer.updateLog(LogEntry(
          type: LogType.resultSuccess,
          message: 'First',
          level: 800,
        ));
        JoshLogBuffer.updateLog(LogEntry(
          type: LogType.responseError,
          message: 'Second',
          level: 1000,
        ));

        // flush() is no-op inside scope
        expect(() => JoshLogBuffer.flush(), returnsNormally);

        // flushAll should emit and clear current scope logs
        expect(() => JoshLogBuffer.flushAll(), returnsNormally);

        // End scope (nothing left to emit)
        expect(() => JoshLogBuffer.endScope(), returnsNormally);
        expect(JoshLogBuffer.inScope, isFalse);
      });

      test('Scoped logging - nested scopes and discard', () {
        JoshLogBuffer.beginScope();
        expect(JoshLogBuffer.inScope, isTrue);

        JoshLogBuffer.updateLog(LogEntry(
          type: LogType.resultError,
          message: 'Outer-1',
          level: 1000,
        ));

        // Inner scope
        JoshLogBuffer.beginScope();
        JoshLogBuffer.updateLog(LogEntry(
          type: LogType.responseSuccess,
          message: 'Inner-1',
          level: 800,
        ));

        // Flush just inner logs without closing scopes
        expect(() => JoshLogBuffer.flushAll(), returnsNormally);

        // Discard inner scope logs (already flushedAll, so nothing left)
        expect(() => JoshLogBuffer.endScope(flush: false), returnsNormally);

        // End outer scope with flush (should only emit 'Outer-1')
        expect(() => JoshLogBuffer.endScope(), returnsNormally);
        expect(JoshLogBuffer.inScope, isFalse);
      });
    });

    group('New Features Tests', () {
      test('JoshLogger.singleLogLine - creates formatted log line', () {
        final logLine = JoshLogger.singleLogLine('Test error message');
        expect(logLine, isA<String>());
        expect(logLine, contains('ErrorMessage'));
        expect(logLine, contains('Test error message'));
      });

      test('EnvironmentUtils - environment detection', () {
        // Test environment detection methods
        expect(EnvironmentUtils.isProduction, isA<bool>());
        expect(EnvironmentUtils.isDevelopment, isA<bool>());
        expect(EnvironmentUtils.currentEnvironment, isA<String>());

        // In test environment, should be development
        expect(EnvironmentUtils.isDevelopment, equals(true));
        expect(EnvironmentUtils.isProduction, equals(false));
      });

      test('EnvironmentUtils - current environment string', () {
        final env = EnvironmentUtils.currentEnvironment;
        expect(env, isNotNull);
        expect(env, isNotEmpty);
      });
    });
  });
}
