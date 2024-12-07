import 'package:flutter/material.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart' as libphonenumber;
import 'package:get_it/get_it.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import '../../models/parsed_number.dart';
import '../../services/logger_service.dart';
import 'phone_parse_lib_phone_number_dialog.dart';
import 'phone_parse_phone_numbers_parser_dialog.dart';

class PhoneParseController implements Disposable {
  final LoggerService logger;

  PhoneParseController({
    required this.logger,
  });

  ///
  /// VARIABLES
  ///

  final phoneNumberController = TextEditingController();

  ///
  /// INIT
  ///

  Future<void> init() async {
    await libphonenumber.init();
  }

  ///
  /// DISPOSE
  ///

  @override
  void onDispose() {
    phoneNumberController.dispose();
  }

  ///
  /// METHODS
  ///

  /// Parses phone number using [PhoneNumbersParser]
  Future<void> triggerPhoneNumbersParser(
    String phoneNumber, {
    required BuildContext context,
  }) async {
    try {
      final parsedNumber = PhoneNumber.parse(phoneNumber);

      final countryCode = parsedNumber.countryCode;
      final international = parsedNumber.international;
      final isoCode = parsedNumber.isoCode;
      final nsn = parsedNumber.nsn;

      final internationalNsn = parsedNumber.formatNsn(
        format: NsnFormat.international,
      );
      final nationalNsn = parsedNumber.formatNsn();

      await showDialog(
        context: context,
        builder: (context) => PhoneParsePhoneNumbersParserDialog(
          phoneNumber: phoneNumber,
          countryCode: countryCode,
          international: international,
          isoCode: isoCode,
          nsn: nsn,
          internationalNsn: internationalNsn,
          nationalNsn: nationalNsn,
        ),
      );
    } catch (e) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('PhoneNumbersParser'),
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  /// Parses phone number using [FlutterLibPhoneNumber]
  Future<void> triggerFlutterLibPhoneNumber(
    String phoneNumber, {
    required BuildContext context,
  }) async {
    try {
      final number = await libphonenumber.parse(phoneNumber);
      final parsedNumber = ParsedNumber.fromMap(number);

      await showDialog(
        context: context,
        builder: (context) => PhoneParseLibPhoneNumberDialog(
          phoneNumber: phoneNumber,
          parsedNumber: parsedNumber,
        ),
      );
    } catch (e) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('LibPhoneNumber'),
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }
}
