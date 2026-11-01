import 'package:flutter_test/flutter_test.dart';
import 'package:hostelhop_mobile/core/utils/validators.dart';

void main() {
  group('Validators.fullPhone', () {
    test('normalises local, country-code and spaced formats to E.164', () {
      expect(Validators.fullPhone('0712345678'), '+256712345678');
      expect(Validators.fullPhone('712345678'), '+256712345678');
      expect(Validators.fullPhone('256712345678'), '+256712345678');
      expect(Validators.fullPhone('+256 712 345 678'), '+256712345678');
    });
  });

  group('Validators.phone', () {
    test('accepts a 9-digit number starting with 7', () {
      expect(Validators.phone('712345678'), isNull);
      expect(Validators.phone('712 345 678'), isNull);
    });

    test('rejects empty, short and non-7 numbers', () {
      expect(Validators.phone(''), isNotNull);
      expect(Validators.phone(null), isNotNull);
      expect(Validators.phone('71234'), isNotNull);
      expect(Validators.phone('812345678'), isNotNull);
    });
  });
}
