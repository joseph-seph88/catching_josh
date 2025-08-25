import 'package:flutter_test/flutter_test.dart';
import 'package:catching_josh/catching_josh.dart';

void main() {
  group('Josh Functions Tests', () {
    group('joshSync Tests', () {
      test('joshSync - successful sync operation', () {
        final result = joshSync(() => 'success');
        expect(result, equals('success'));
      });

      test('joshSync - sync operation with error (default behavior)', () {
        expect(() {
          joshSync(() {
            throw Exception('Test error');
          });
        }, throwsA(isA<JoshException>()));
      });

      test('joshSync - with messageTitle', () {
        final result = joshSync(
          () => 'success',
          messageTitle: 'Test operation',
        );
        expect(result, equals('success'));
      });

      test('joshSync - with errorMessage', () {
        expect(() {
          joshSync(
            () => throw Exception('Test error'),
            errorMessage: 'Custom error message',
          );
        }, throwsA(isA<JoshException>()));
      });

      test('joshSync - disable success log', () {
        final result = joshSync(
          () => 'success',
          showSuccessLog: false,
        );
        expect(result, equals('success'));
      });

      test('joshSync - disable error log', () {
        expect(() {
          joshSync(
            () => throw Exception('Test error'),
            showErrorLog: false,
          );
        }, throwsA(isA<JoshException>()));
      });
    });

    group('joshAsync Tests', () {
      test('joshAsync - successful async operation', () async {
        final result = await joshAsync(() async {
          await Future.delayed(Duration(milliseconds: 1));
          return 'async success';
        });
        expect(result, equals('async success'));
      });

      test('joshAsync - async operation with error (default behavior)',
          () async {
        expect(() async {
          await joshAsync(() async {
            await Future.delayed(Duration(milliseconds: 1));
            throw Exception('Test async error');
          });
        }, throwsA(isA<JoshException>()));
      });

      test('joshAsync - with returnNull error handling', () async {
        final result = await joshAsync(
          () async {
            await Future.delayed(Duration(milliseconds: 1));
            throw Exception('Test async error');
          },
          errorHandleType: ErrorHandleType.returnNull,
        );
        expect(result, isNull);
      });

      test('joshAsync - with rethrow error handling', () async {
        expect(() async {
          await joshAsync(
            () async {
              await Future.delayed(Duration(milliseconds: 1));
              throw Exception('Test async error');
            },
            errorHandleType: ErrorHandleType.rethrowError,
          );
        }, throwsA(isA<Exception>()));
      });

      test('joshAsync - with messageTitle and errorMessage', () async {
        final result = await joshAsync(
          () async {
            await Future.delayed(Duration(milliseconds: 1));
            return 'success';
          },
          messageTitle: 'Test async operation',
          errorMessage: 'Custom error message',
        );
        expect(result, equals('success'));
      });

      test('joshAsync - disable success log', () async {
        final result = await joshAsync(
          () async {
            await Future.delayed(Duration(milliseconds: 1));
            return 'success';
          },
          showSuccessLog: false,
        );
        expect(result, equals('success'));
      });

      test('joshAsync - disable error log', () async {
        expect(() async {
          await joshAsync(
            () async {
              await Future.delayed(Duration(milliseconds: 1));
              throw Exception('Test async error');
            },
            showErrorLog: false,
          );
        }, throwsA(isA<JoshException>()));
      });
    });

    group('joshReq Tests', () {
      test('joshReq - successful request operation', () async {
        final result = await joshReq(() async {
          await Future.delayed(Duration(milliseconds: 1));
          return MockHttpResponse(200, 'success data');
        });
        expect(result.statusCode, equals(200));
        expect(result.data, equals('success data'));
      });

      test('joshReq - request operation with error (default behavior)',
          () async {
        expect(() async {
          await joshReq(() async {
            await Future.delayed(Duration(milliseconds: 1));
            throw Exception('Test request error');
          });
        }, throwsA(isA<JoshException>()));
      });

      test('joshReq - with rethrow error handling', () async {
        expect(() async {
          await joshReq(
            () async {
              await Future.delayed(Duration(milliseconds: 1));
              throw Exception('Test request error');
            },
            errorHandleType: ErrorHandleType.rethrowError,
          );
        }, throwsA(isA<Exception>()));
      });

      test('joshReq - with messageTitle and errorMessage', () async {
        final result = await joshReq(
          () async {
            await Future.delayed(Duration(milliseconds: 1));
            return MockHttpResponse(200, 'success data');
          },
          messageTitle: 'Test request',
          errorMessage: 'Custom error message',
        );
        expect(result.statusCode, equals(200));
        expect(result.data, equals('success data'));
      });

      test('joshReq - null response handling', () async {
        expect(() async {
          await joshReq(() async {
            await Future.delayed(Duration(milliseconds: 1));
            return null;
          });
        }, throwsA(isA<JoshException>()));
      });

      test('joshReq - disable success log', () async {
        final result = await joshReq(
          () async {
            await Future.delayed(Duration(milliseconds: 1));
            return MockHttpResponse(200, 'success data');
          },
          showSuccessLog: false,
        );
        expect(result.statusCode, equals(200));
        expect(result.data, equals('success data'));
      });

      test('joshReq - disable error log', () async {
        expect(() async {
          await joshReq(
            () async {
              await Future.delayed(Duration(milliseconds: 1));
              throw Exception('Test request error');
            },
            showErrorLog: false,
          );
        }, throwsA(isA<JoshException>()));
      });
    });

    group('Error Handling Tests', () {
      test('ErrorHandleType enum values', () {
        expect(ErrorHandleType.returnNull.value, equals('null'));
        expect(ErrorHandleType.rethrowError.value, equals('rethrow'));
        expect(ErrorHandleType.throwError.value, equals('throw'));
      });

      test('ErrorHandleType toString', () {
        expect(ErrorHandleType.returnNull.toString(), equals('null'));
        expect(ErrorHandleType.rethrowError.toString(), equals('rethrow'));
        expect(ErrorHandleType.throwError.toString(), equals('throw'));
      });
    });

    group('Integration Tests', () {
      test('Combined sync and async operations', () async {
        // Sync operation
        final syncResult = joshSync(() => 'sync success');
        expect(syncResult, equals('sync success'));

        // Async operation
        final asyncResult = await joshAsync(() async {
          await Future.delayed(Duration(milliseconds: 1));
          return 'async success';
        });
        expect(asyncResult, equals('async success'));

        // Request operation
        final requestResult = await joshReq(() async {
          await Future.delayed(Duration(milliseconds: 1));
          return MockHttpResponse(200, 'request success');
        });
        expect(requestResult.statusCode, equals(200));
        expect(requestResult.data, equals('request success'));
      });

      test('Error handling across different functions', () async {
        // Sync error
        expect(() {
          joshSync(() => throw Exception('Sync error'));
        }, throwsA(isA<JoshException>()));

        // Async error with returnNull
        final asyncResult = await joshAsync(
          () async {
            await Future.delayed(Duration(milliseconds: 1));
            throw Exception('Async error');
          },
          errorHandleType: ErrorHandleType.returnNull,
        );
        expect(asyncResult, isNull);

        // Request error with rethrow
        expect(() async {
          await joshReq(
            () async {
              await Future.delayed(Duration(milliseconds: 1));
              throw Exception('Request error');
            },
            errorHandleType: ErrorHandleType.rethrowError,
          );
        }, throwsA(isA<Exception>()));
      });
    });
  });
}

// Mock HTTP response class for testing
class MockHttpResponse {
  final int statusCode;
  final dynamic data;

  MockHttpResponse(this.statusCode, this.data);
}
