import 'package:flutter/services.dart';

/// Channel used to deliver the verification code (SPEC 5.1).
enum PhoneCodeChannel { whatsapp, sms }

/// Country calling codes offered in the phone step (+55 is the default).
enum CallingCode {
  brazil('BR', '55', 11, 11),
  portugal('PT', '351', 9, 9),
  argentina('AR', '54', 10, 11),
  unitedStates('US', '1', 10, 10);

  new(this.isoCode, this.dialCode, this.minDigits, this.maxDigits);

  final String isoCode;
  final String dialCode;

  /// National number length range (digits only).
  final int minDigits;
  final int maxDigits;

  String get flag =>
      String.fromCharCodes(isoCode.codeUnits.map((c) => 0x1F1E6 + c - 0x41));
}

abstract final class PhoneNumbers {
  static String digitsOnly(String value) =>
      value.replaceAll(RegExp('[^0-9]'), '');

  /// Brazilian mobiles: DDD (11–99) + 9 + 8 digits.
  static final _brMobile = RegExp(r'^[1-9][1-9]9[0-9]{8}$');

  static bool isValidNational(CallingCode code, String national) {
    final digits = digitsOnly(national);
    if (code == CallingCode.brazil) return _brMobile.hasMatch(digits);
    return digits.length >= code.minDigits && digits.length <= code.maxDigits;
  }

  /// E.164, e.g. +5511987654321 (format stored in user_private.phone).
  static String toE164(CallingCode code, String national) =>
      '+${code.dialCode}${digitsOnly(national)}';

  /// Masks for display: "+55 (11) 98765-4321"-style for Brazil.
  static String formatNational(CallingCode code, String national) {
    final d = digitsOnly(national);
    if (code != CallingCode.brazil) return d;
    if (d.length <= 2) return d.isEmpty ? '' : '($d';
    final ddd = d.substring(0, 2);
    final rest = d.substring(2);
    if (rest.length <= 5) return '($ddd) $rest';
    return '($ddd) ${rest.substring(0, 5)}-${rest.substring(5)}';
  }
}

/// Applies [PhoneNumbers.formatNational] while typing.
class NationalPhoneFormatter extends TextInputFormatter {
  new(this.code);

  final CallingCode code;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = PhoneNumbers.digitsOnly(newValue.text);
    if (digits.length > code.maxDigits) {
      digits = digits.substring(0, code.maxDigits);
    }
    final text = PhoneNumbers.formatNational(code, digits);
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
