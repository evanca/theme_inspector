import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:theme_inspector/src/shared/contrast.dart';

const Color white = Color(0xFFFFFFFF);
const Color black = Color(0xFF000000);

void main() {
  group('contrastRatio', () {
    test('black on white is the maximum, 21:1', () {
      expect(contrastRatio(black, white), closeTo(21, 0.01));
    });

    test('is symmetric and 1:1 for identical colours', () {
      const Color purple = Color(0xFF6750A4);
      expect(contrastRatio(purple, purple), closeTo(1, 0.001));
      expect(
        contrastRatio(white, purple),
        closeTo(contrastRatio(purple, white), 0.001),
      );
    });

    test('matches the published ratio for Material 3 primary on white', () {
      // #6750A4 with #FFFFFF is 6.4:1 in WCAG contrast checkers.
      expect(
        formatContrastRatio(contrastRatio(white, const Color(0xFF6750A4))),
        '6.4',
      );
    });

    test('composites a transparent background over the backdrop', () {
      // A fully transparent tile shows the surface behind it, so black text
      // on it contrasts like black on that surface, not like black on black.
      expect(
        contrastRatio(black, const Color(0x00000000), backdrop: white),
        closeTo(21, 0.01),
      );
    });
  });

  group('ContrastGrade.of', () {
    test('uses the WCAG thresholds for text', () {
      expect(ContrastGrade.of(7), ContrastGrade.aaa);
      expect(ContrastGrade.of(6.99), ContrastGrade.aa);
      expect(ContrastGrade.of(4.5), ContrastGrade.aa);
      expect(ContrastGrade.of(4.49), ContrastGrade.aaLarge);
      expect(ContrastGrade.of(3), ContrastGrade.aaLarge);
      expect(ContrastGrade.of(2.99), ContrastGrade.low);
    });
  });

  group('formatContrastRatio', () {
    test('truncates so a failing ratio never displays as passing', () {
      // 4.49 fails AA; rounding would print "4.5", the AA threshold.
      expect(formatContrastRatio(4.49), '4.4');
      expect(formatContrastRatio(21), '21.0');
    });
  });
}
