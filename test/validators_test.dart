import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_assignment/core/utils/validators.dart';

void main() {
  group('Validators Tests', () {
    group('Email Validation', () {
      test('should return true for valid email addresses', () {
        final validEmails = [
          'test@example.com',
          'user.name@domain.co.uk',
          'user+tag@example.org',
          'test123@test-domain.com',
        ];

        for (final email in validEmails) {
          expect(Validators.isValidEmail(email), true, reason: 'Failed for: $email');
        }
      });

      test('should return false for invalid email addresses', () {
        final invalidEmails = [
          'invalid-email',
          '@domain.com',
          'user@',
          'user@@domain.com',
          'user@domain',
          '',
          'user name@domain.com',
        ];

        for (final email in invalidEmails) {
          expect(Validators.isValidEmail(email), false, reason: 'Failed for: $email');
        }
      });

      test('validateEmail should return null for valid emails', () {
        expect(Validators.validateEmail('test@example.com'), isNull);
        expect(Validators.validateEmail('user@domain.org'), isNull);
      });

      test('validateEmail should return error message for invalid emails', () {
        expect(Validators.validateEmail(''), 'Email is required');
        expect(Validators.validateEmail(null), 'Email is required');
        expect(Validators.validateEmail('invalid-email'), 'Please enter a valid email');
        expect(Validators.validateEmail('user@'), 'Please enter a valid email');
      });
    });

    group('Password Validation', () {
      test('should return true for valid passwords', () {
        final validPasswords = [
          'password123',
          '123456',
          'mypassword',
          'P@ssw0rd!',
          'verylongpassword',
        ];

        for (final password in validPasswords) {
          expect(Validators.isValidPassword(password), true, reason: 'Failed for: $password');
        }
      });

      test('should return false for invalid passwords', () {
        final invalidPasswords = [
          '',
          '12345',
          'pass',
          'abc',
        ];

        for (final password in invalidPasswords) {
          expect(Validators.isValidPassword(password), false, reason: 'Failed for: $password');
        }
      });

      test('validatePassword should return null for valid passwords', () {
        expect(Validators.validatePassword('password123'), isNull);
        expect(Validators.validatePassword('123456'), isNull);
        expect(Validators.validatePassword('mypassword'), isNull);
      });

      test('validatePassword should return error message for invalid passwords', () {
        expect(Validators.validatePassword(''), 'Password is required');
        expect(Validators.validatePassword(null), 'Password is required');
        expect(Validators.validatePassword('12345'), 'Password must be at least 6 characters');
        expect(Validators.validatePassword('abc'), 'Password must be at least 6 characters');
      });
    });
  });
}
