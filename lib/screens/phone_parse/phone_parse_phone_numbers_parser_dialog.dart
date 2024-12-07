import 'package:flutter/material.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class PhoneParsePhoneNumbersParserDialog extends StatelessWidget {
  final String phoneNumber;
  final String countryCode;
  final String international;
  final IsoCode isoCode;
  final String nsn;
  final String internationalNsn;
  final String nationalNsn;

  const PhoneParsePhoneNumbersParserDialog({
    required this.phoneNumber,
    required this.countryCode,
    required this.international,
    required this.isoCode,
    required this.nsn,
    required this.internationalNsn,
    required this.nationalNsn,
  });

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('PhoneNumbersParser'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text('Number'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(phoneNumber),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                const Expanded(
                  child: Text('Country code'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    countryCode,
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                const Expanded(
                  child: Text('International'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    international,
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                const Expanded(
                  child: Text('ISO code'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    isoCode.name,
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                const Expanded(
                  child: Text('Nsn'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    nsn,
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                const Expanded(
                  child: Text('International Nsn'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    internationalNsn,
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                const Expanded(
                  child: Text('National Nsn'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    nationalNsn,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
