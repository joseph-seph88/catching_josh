import 'package:flutter_test/flutter_test.dart';
import 'package:catching_josh/catching_josh.dart';

void main() {
  group('Josh Functions Tests', () {
    test('josh() - sync operation with null return', () {
      final result = josh(() {
        throw Exception('Test error');
      });

      expect(result, isNull);
    });

    test('josh() - sync operation with throw return', () {
      expect(() {
        josh(
          () => throw Exception('Test error'),
          returnType: 'throw',
        );
      }, throwsA(isA<Exception>()));
    });

    test('josh() - sync operation with rethrow return', () {
      expect(() {
        josh(
          () => throw Exception('Test error'),
          returnType: 'rethrow',
        );
      }, throwsA(isA<Exception>()));
    });

    test('josh() - sync operation with exception return', () {
      expect(() {
        josh(
          () => throw Exception('Test error'),
          returnType: 'exception',
        );
      }, throwsA(isA<Exception>()));
    });

    test('josh() - successful sync operation', () {
      final result = josh(() => 'success');
      expect(result, equals('success'));
    });

    test('jsAsync() - async operation with null return', () async {
      final result = await joshAsync(() async {
        await Future.delayed(Duration(milliseconds: 1));
        throw Exception('Test async error');
      });

      expect(result, isNull);
    });

    test('jsAsync() - successful async operation', () async {
      final result = await joshAsync(() async {
        await Future.delayed(Duration(milliseconds: 1));
        return 'async success';
      });

      expect(result, equals('async success'));
    });

    test('jsVoid() - void operation with null return', () {
      expect(() {
        joshVoid(() {
          throw Exception('Test void error');
        });
      }, returnsNormally);
    });

    test('jsVoid() - void operation with throw return', () {
      expect(() {
        joshVoid(
          () => throw Exception('Test void error'),
          returnType: 'throw',
        );
      }, throwsA(isA<Exception>()));
    });

    test('jsVoid() - successful void operation', () {
      expect(() {
        joshVoid(() {
          // Do nothing
        });
      }, returnsNormally);
    });

    test('josh() - with context', () {
      final result = josh(
        () => throw Exception('Test error with context'),
        context: 'TestContext',
      );

      expect(result, isNull);
    });
  });
}
