import 'package:flutter/material.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart' as libphonenumber;

import '../../../models/parsed_number.dart';
import '../../../services/logger_service.dart';
import '../../../services/users_table_service.dart';

class OnboardingNumberController extends ValueNotifier<({String? countryCode, String? number})> {
  final LoggerService logger;
  final UsersTableService usersTable;

  OnboardingNumberController({
    required this.logger,
    required this.usersTable,
  }) : super((countryCode: null, number: null));

  ///
  /// INIT
  ///

  Future<void> init() async {
    await libphonenumber.init();
  }

  ///
  /// METHODS
  ///

  void updateState({
    String? newCountryCode,
    String? newNumber,
  }) {
    if (newCountryCode != null) {
      final oldNumber = value.number;
      value = (countryCode: newCountryCode.trim(), number: oldNumber);
    }

    if (newNumber != null) {
      final oldCountryCode = value.countryCode;
      value = (countryCode: oldCountryCode, number: newNumber.trim());
    }
  }

  /// Check if both numbers exist
  bool isStateProper(({String? countryCode, String? number}) passedState) => (passedState.countryCode?.isNotEmpty ?? false) && (passedState.number?.isNotEmpty ?? false);

  Future<ParsedNumber?> getParsedNumberFromState() async => parsePhoneNumber(
        phoneNumber: '${value.countryCode}${value.number}',
      );

  /// Parses phone number using [FlutterLibPhoneNumber]
  Future<ParsedNumber?> parsePhoneNumber({required String phoneNumber}) async {
    try {
      final number = await libphonenumber.parse(phoneNumber);
      final parsedNumber = ParsedNumber.fromMap(number);

      logger.t('OnboardingNumberController -> parsePhoneNumber() -> success!');

      return parsedNumber;
    } catch (e) {
      logger.e('OnboardingNumberController -> parsePhoneNumber() -> $e');
      return null;
    }
  }

  /// Checks if any user in the database is registered with the passed phone number
  Future<bool> getUserExistsInDatabase({required ParsedNumber parsedNumber}) async {
    final result = await usersTable.searchUsersByPhoneNumber(
      query: parsedNumber.international,
    );

    return result?.isNotEmpty ?? false;
  }
}
