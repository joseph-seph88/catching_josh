import 'package:flutter_test/flutter_test.dart';
import 'package:catching_js/catching_js.dart';

void main() {
  group('JS Functions Tests', () {
    test('js() - sync operation with null return', () {
      final result = js(() {
        throw Exception('Test error');
      });

      expect(result, isNull);
    });

    test('js() - sync operation with throw return', () {
      expect(() {
        js(
          () => throw Exception('Test error'),
          returnType: 'throw',
        );
      }, throwsA(isA<Exception>()));
    });

    test('js() - sync operation with rethrow return', () {
      expect(() {
        js(
          () => throw Exception('Test error'),
          returnType: 'rethrow',
        );
      }, throwsA(isA<Exception>()));
    });

    test('js() - sync operation with exception return', () {
      expect(() {
        js(
          () => throw Exception('Test error'),
          returnType: 'exception',
        );
      }, throwsA(isA<Exception>()));
    });

    test('js() - successful sync operation', () {
      final result = js(() => 'success');
      expect(result, equals('success'));
    });

    test('jsAsync() - async operation with null return', () async {
      final result = await jsAsync(() async {
        await Future.delayed(Duration(milliseconds: 1));
        throw Exception('Test async error');
      });

      expect(result, isNull);
    });

    test('jsAsync() - successful async operation', () async {
      final result = await jsAsync(() async {
        await Future.delayed(Duration(milliseconds: 1));
        return 'async success';
      });

      expect(result, equals('async success'));
    });

    test('jsVoid() - void operation with null return', () {
      expect(() {
        jsVoid(() {
          throw Exception('Test void error');
        });
      }, returnsNormally);
    });

    test('jsVoid() - void operation with throw return', () {
      expect(() {
        jsVoid(
          () => throw Exception('Test void error'),
          returnType: 'throw',
        );
      }, throwsA(isA<Exception>()));
    });

    test('jsVoid() - successful void operation', () {
      expect(() {
        jsVoid(() {
          // Do nothing
        });
      }, returnsNormally);
    });

    test('js() - with context', () {
      final result = js(
        () => throw Exception('Test error with context'),
        context: 'TestContext',
      );

      expect(result, isNull);
    });
  });
}
