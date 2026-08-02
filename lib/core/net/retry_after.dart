/// Parsing of the `Retry-After` header.
///
/// RFC 9110 allows two forms and Cloudflare uses both depending on the edge
/// that answered: a delay in seconds, or an HTTP-date. The prototype only
/// handled the integer form, so date-form throttles were ignored entirely.
library;

const List<String> _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', //
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

/// Returns the delay requested by the server, or null if the header is absent
/// or unparseable. [now] is injectable so the date form is testable.
Duration? parseRetryAfter(String? header, {DateTime? now}) {
  if (header == null) return null;
  final value = header.trim();
  if (value.isEmpty) return null;

  final seconds = int.tryParse(value);
  if (seconds != null) {
    return seconds <= 0 ? Duration.zero : Duration(seconds: seconds);
  }

  final date = _parseHttpDate(value);
  if (date == null) return null;
  final delta = date.difference((now ?? DateTime.now()).toUtc());
  return delta.isNegative ? Duration.zero : delta;
}

/// Parses the IMF-fixdate form, e.g. `Wed, 21 Oct 2015 07:28:00 GMT`.
///
/// `DateTime.parse` does not accept it, and pulling in a date package for one
/// header would be disproportionate.
DateTime? _parseHttpDate(String value) {
  final m = RegExp(
    r'^[A-Za-z]{3},\s+(\d{1,2})\s+([A-Za-z]{3})\s+(\d{4})\s+'
    r'(\d{2}):(\d{2}):(\d{2})\s+GMT$',
  ).firstMatch(value);
  if (m == null) return null;

  final monthIndex = _months.indexWhere(
    (name) => name.toLowerCase() == m.group(2)!.toLowerCase(),
  );
  if (monthIndex < 0) return null;

  return DateTime.utc(
    int.parse(m.group(3)!),
    monthIndex + 1,
    int.parse(m.group(1)!),
    int.parse(m.group(4)!),
    int.parse(m.group(5)!),
    int.parse(m.group(6)!),
  );
}
