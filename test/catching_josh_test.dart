import 'package:flutter_test/flutter_test.dart';
import 'package:catching_josh/catching_josh.dart';

void main() {
  group('Josh Functions Tests', () {
    group('joshSync Tests', () {
      test('joshSync - successful sync operation', () {
        final result = joshSync(() => 'success');
        expect(result.data, equals('success'));
        expect(result.dataType, equals('String'));
        expect(result.errorMessage, isNull);
      });

      test('joshSync - sync operation with error', () {
        final result = joshSync(() {
          throw Exception('Test error');
        });
        expect(result.data, isNull);
        expect(result.errorMessage, isNull);
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

      test('joshReq - null response handling', () async {
        final result = await joshReq(() async {
          await Future.delayed(Duration(milliseconds: 1));
          return null;
        });
        expect(result.statusMessage, equals('Response is Null'));
        expect(result.data, isNull);
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
  });
}
