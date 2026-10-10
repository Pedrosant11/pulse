import 'package:pulse/app/constants.dart';

enum PasswordStrength { weak, fair, good, strong }

/// Client-side validation. The server enforces the same rules (Supabase
/// password policy and the profiles birth_date check).
abstract final class AuthValidators {
  static final _email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');
  static final _letter = RegExp('[A-Za-zÀ-ÿ]');
  static final _digit = RegExp('[0-9]');
  static final _upper = RegExp('[A-ZÀ-Þ]');
  static final _lower = RegExp('[a-zß-ÿ]');
  static final _symbol = RegExp(r'[^A-Za-zÀ-ÿ0-9\s]');

  static const minPasswordLength = 8;

  static bool isValidEmail(String value) => _email.hasMatch(value.trim());

  /// Minimum accepted by the server: 8+ chars with letters and digits.
  static bool isPasswordAccepted(String value) =>
      value.length >= minPasswordLength &&
      _letter.hasMatch(value) &&
      _digit.hasMatch(value);

  static PasswordStrength passwordStrength(String value) {
    if (!isPasswordAccepted(value)) return PasswordStrength.weak;
    var score = 0;
    if (value.length >= 12) score++;
    if (_upper.hasMatch(value) && _lower.hasMatch(value)) score++;
    if (_symbol.hasMatch(value)) score++;
    return switch (score) {
      0 => PasswordStrength.fair,
      1 => PasswordStrength.good,
      _ => PasswordStrength.strong,
    };
  }

  /// Completed years between [birthDate] and [today].
  static int ageOn(DateTime birthDate, DateTime today) {
    var age = today.year - birthDate.year;
    final hadBirthday =
        today.month > birthDate.month ||
        (today.month == birthDate.month && today.day >= birthDate.day);
    if (!hadBirthday) age--;
    return age;
  }

  static bool isAdult(DateTime birthDate, {DateTime? today}) =>
      ageOn(birthDate, today ?? DateTime.now()) >= AppConstants.minAge;
}
