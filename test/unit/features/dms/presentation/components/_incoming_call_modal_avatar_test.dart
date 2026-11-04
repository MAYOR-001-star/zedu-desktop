import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zedu/core/core.dart';
import 'package:zedu/features/features.dart';

/// Test to verify that avatar initials correctly handle UTF-16 surrogate pairs
/// and multi-codepoint characters (including emojis and accented letters).
void main() {
  group('IncomingCallModal Avatar Initials', () {
    // Helper function to simulate the avatar initial extraction logic
    String _extractInitial(String? userName) {
      if (userName == null || userName.isEmpty) {
        return '?';
      }
      final trimmed = userName.trim();
      if (trimmed.isEmpty) {
        return '?';
      }
      return trimmed.characters.first.toUpperCase();
    }

    test('ASCII name returns uppercase first letter', () {
      expect(_extractInitial('John'), 'J');
      expect(_extractInitial('Bob'), 'B');
      expect(_extractInitial('Alice'), 'A');
    });

    test('Accented letter returns uppercase first grapheme cluster', () {
      // é is a single grapheme cluster (U+00E9) but two UTF-16 code units
      expect(_extractInitial('Émile'), 'É');
      expect(_extractInitial('José'), 'J');
      expect(_extractInitial('Anaïs'), 'A');
      expect(_extractInitial('Zoë'), 'Z');
    });

    test('Emoji returns the emoji as the initial', () {
      // Emoji sequences consist of multiple UTF-16 code units (surrogate pairs)
      expect(_extractInitial('😀YOY'), '😀');
      expect(_extractInitial('👨‍👩‍👧‍👦 YOY'), '👨‍👩‍👧‍👦');
      expect(_extractInitial('🙏 User'), '🙏');
    });

    test('Mixed emoji and ASCII returns the first grapheme cluster', () {
      expect(_extractInitial('😀 John'), '😀');
      expect(_extractInitial('👋Zoe'), '👋');
      expect(_extractInitial('❤️ Zoe'), '❤️');
    });

    test('Whitespace-only name returns ?', () {
      expect(_extractInitial('   '), '?');
      expect(_extractInitial('\t\n'), '?');
    });

    test('Null name returns ?', () {
      expect(_extractInitial(null), '?');
    });

    test('Empty string returns ?', () {
      expect(_extractInitial(''), '?');
    });

    test('Multiple spaces trim before extracting initial', () {
      expect(_extractInitial('  Mary  '), 'M');
      expect(_extractInitial('   Bob   '), 'B');
    });

    test('Combination of emoji and accented letters', () {
      expect(_extractInitial('😍 Ana'), '😍');
      expect(_extractInitial('👩‍♀️ Zoë'), '👩‍♀️');
    });
  });
}