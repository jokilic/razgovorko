import 'package:flutter/material.dart';

import '../../../services/logger_service.dart';

class OnboardingPasswordController extends ValueNotifier<String?> {
  final LoggerService logger;

  OnboardingPasswordController({
    required this.logger,
  }) : super(null);

  ///
  /// METHODS
  ///

  /// Check if `password` is proper
  bool isStateProper(String? passedPassword) => (passedPassword?.length ?? 0) >= 8;
}
