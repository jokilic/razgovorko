class ParsedNumber {
  final String countryCode;
  final String e164;
  final String national;
  final String type;
  final String international;
  final String nationalNumber;

  ParsedNumber({
    required this.countryCode,
    required this.e164,
    required this.national,
    required this.type,
    required this.international,
    required this.nationalNumber,
  });

  factory ParsedNumber.fromMap(Map<String, dynamic> map) => ParsedNumber(
        countryCode: map['country_code'] as String,
        e164: map['e164'] as String,
        national: map['national'] as String,
        type: map['type'] as String,
        international: map['international'] as String,
        nationalNumber: map['national_number'] as String,
      );

  @override
  String toString() => 'ParsedNumber(countryCode: $countryCode, e164: $e164, national: $national, type: $type, international: $international, nationalNumber: $nationalNumber)';

  @override
  bool operator ==(covariant ParsedNumber other) {
    if (identical(this, other)) {
      return true;
    }

    return other.countryCode == countryCode &&
        other.e164 == e164 &&
        other.national == national &&
        other.type == type &&
        other.international == international &&
        other.nationalNumber == nationalNumber;
  }

  @override
  int get hashCode => countryCode.hashCode ^ e164.hashCode ^ national.hashCode ^ type.hashCode ^ international.hashCode ^ nationalNumber.hashCode;
}
