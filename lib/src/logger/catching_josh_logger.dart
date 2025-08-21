import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Standard and efficient error logger for JS functions
class CatchingJoshLogger {
  static const String _packageName = 'CatchingJosh';

  /// Log error with environment-aware logging
  static void logError(
    Object error,
    StackTrace? stackTrace, {
    String? context,
  }) {
    // 1. 개발 환경에서만 상세 로깅
    if (kDebugMode) {
      developer.log(
        'Error: $error',
        name: _packageName,
        level: 1000,
      );

      if (context != null) {
        developer.log(
          '┌─ Context ──────────────────┐',
          name: _packageName,
          level: 1000,
        );
        developer.log(
          '│ $context',
          name: _packageName,
          level: 1000,
        );
        developer.log(
          '└─────────────────────────────┘',
          name: _packageName,
          level: 1000,
        );
      }

      if (stackTrace != null) {
        final location = _extractErrorLocation(stackTrace);
        if (location.isNotEmpty) {
          developer.log(
            '┌─ Location ──────────────────┐',
            name: _packageName,
            level: 1000,
          );
          developer.log(
            '│ $location',
            name: _packageName,
            level: 1000,
          );
          developer.log(
            '└─────────────────────────────┘',
            name: _packageName,
            level: 1000,
          );
        }
      }

      // 전체 에러 정보 (디버깅용)
      developer.log(
        '┌─ Full Error Details ──────────┐',
        name: _packageName,
        level: 1000,
      );
      developer.log(
        '│ Error: $error',
        name: _packageName,
        level: 1000,
      );
      if (stackTrace != null) {
        developer.log(
          '│ StackTrace: Available',
          name: _packageName,
          level: 1000,
        );
      }
      developer.log(
        '└─────────────────────────────┘',
        name: _packageName,
        level: 1000,
      );
    }

    // 2. 모든 환경에서 기본 에러 메시지 출력
    print('┌─ Error ─────────────────────┐');
    print('│ $error');
    print('└─────────────────────────────┘');

    // 3. 컨텍스트가 있으면 추가 출력
    if (context != null) {
      print('┌─ Context ──────────────────┐');
      print('│ $context');
      print('└─────────────────────────────┘');
    }

    // 4. 로그 구분선
    print('================================');
  }

  /// Extract error location from stack trace
  static String _extractErrorLocation(StackTrace stackTrace) {
    try {
      final lines = stackTrace.toString().split('\n');

      // josh() 함수 호출 다음에 오는 실제 에러 위치 찾기
      for (int i = 0; i < lines.length - 1; i++) {
        final line = lines[i];

        // josh() 함수 호출 건너뛰기
        if (line.contains('josh(') ||
            line.contains('joshAsync(') ||
            line.contains('joshVoid(')) {
          continue;
        }

        // 파일명:줄번호 패턴 찾기
        final match =
            RegExp(r'#\d+\s+\w+\s+\((.+):(\d+):(\d+)\)').firstMatch(line);
        if (match != null) {
          final fileName = match.group(1)?.split('/').last ?? 'unknown';
          final lineNumber = match.group(2) ?? '?';
          return '$fileName:$lineNumber';
        }
      }
    } catch (e) {
      // 파싱 실패시 빈 문자열 반환
      return '';
    }

    return '';
  }
}
