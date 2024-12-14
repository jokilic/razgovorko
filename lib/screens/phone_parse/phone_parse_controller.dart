import 'package:flutter/material.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart' as libphonenumber;
import 'package:get_it/get_it.dart';

import '../../models/parsed_number.dart';
import '../../services/logger_service.dart';
import 'phone_parse_lib_phone_number_dialog.dart';

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

  /// Parses phone number using [FlutterLibPhoneNumber]
  Future<void> parsePhoneNumber(
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
