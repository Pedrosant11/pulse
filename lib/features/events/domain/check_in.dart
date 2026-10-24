/// Check-in: proof of presence at a party (GPS at the venue or the
/// producer's QR). The rules live in the database (`check_in_gps`,
/// `check_in_qr`); this only decides when to show the card and reads the QR.
library;

/// The check-in opens 1 h before the start and closes at the end
/// (`checkin_hours_before` on the server).
bool checkInOpen({
  required DateTime startsAt,
  required DateTime endsAt,
  required DateTime now,
}) =>
    !now.isBefore(startsAt.subtract(const Duration(hours: 1))) &&
    now.isBefore(endsAt);

const _qrScheme = 'pulse-checkin';

/// What the producer's QR carries: the party and the code of the minute.
String checkInQrPayload(String eventId, String code) =>
    '$_qrScheme:$eventId:$code';

/// The code inside a scanned QR, or `null` when it isn't this party's
/// check-in QR. A bare 8-character code (typed by hand) is accepted too.
String? parseCheckInQr(String raw, String eventId) {
  final text = raw.trim();
  final parts = text.split(':');
  if (parts.length == 3 && parts[0] == _qrScheme) {
    return parts[1] == eventId && parts[2].isNotEmpty ? parts[2] : null;
  }
  return RegExp(r'^[0-9A-Fa-f]{8}$').hasMatch(text) ? text : null;
}

/// The producer's current code (`checkin_code()`), valid until [expiresAt].
class CheckInCode {
  const new({
    required this.code,
    required this.expiresAt,
    required this.open,
    required this.checkedIn,
  });

  factory fromJson(Map<String, dynamic> json) => CheckInCode(
    code: json['code'] as String,
    expiresAt: DateTime.parse(json['expires_at'] as String),
    open: json['open'] as bool,
    checkedIn: (json['checked_in'] as num).toInt(),
  );

  final String code;
  final DateTime expiresAt;
  final bool open;
  final int checkedIn;
}
