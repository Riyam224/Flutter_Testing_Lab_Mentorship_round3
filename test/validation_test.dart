import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart';

void main() {
  group('Email validation', () {
    test('Valid email returns true', () {
      expect(isValidEmail('user@example.com'), true);
    });

    test('Invalid email "a@" returns false', () {
      expect(isValidEmail('a@'), false);
    });

    test('Invalid email "@b" returns false', () {
      expect(isValidEmail('@b'), false);
    });
  });

  group('Password validation', () {
    test('Strong password returns true', () {
      expect(isStrongPassword('Aa@12345'), true);
    });

    test('Weak password returns false', () {
      expect(isStrongPassword('12345'), false);
    });

    // todo test edge cases _______

    test('Valid email with subdomain returns true', () {
      expect(isValidEmail('name@mail.example.co'), true);
    });

    test('Email with leading/trailing spaces is valid after trim', () {
      expect(isValidEmail('   user@example.com  '), true);
    });

    test('Password exactly 8 chars passes', () {
      expect(isStrongPassword('Aa@12345'), true);
    });

    test('Password with only lowercase fails', () {
      expect(isStrongPassword('abcdefgh'), false);
    });

    test('Password with no number fails', () {
      expect(isStrongPassword('Aa@aaaaa'), false);
    });

    test('Password with no symbol fails', () {
      expect(isStrongPassword('Aa123456'), false);
    });
  });
}
