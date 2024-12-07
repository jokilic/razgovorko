import 'package:flutter/material.dart';

import '../../models/parsed_number.dart';

class PhoneParseLibPhoneNumberDialog extends StatelessWidget {
  final String phoneNumber;
  final ParsedNumber parsedNumber;

  const PhoneParseLibPhoneNumberDialog({
    required this.phoneNumber,
    required this.parsedNumber,
  });

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('LibPhoneNumber'),
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
                    parsedNumber.countryCode,
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                const Expanded(
                  child: Text('e164'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    parsedNumber.e164,
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                const Expanded(
                  child: Text('National'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    parsedNumber.national,
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                const Expanded(
                  child: Text('Type'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    parsedNumber.type,
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
                    parsedNumber.international,
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                const Expanded(
                  child: Text('National number'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    parsedNumber.nationalNumber,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
