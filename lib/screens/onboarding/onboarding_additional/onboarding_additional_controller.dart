import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../services/logger_service.dart';

class OnboardingAdditionalController extends ValueNotifier<
    ({
      String? avatarUrl,
      String? aboutMe,
      String? status,
      String? location,
      DateTime? dateOfBirth,
    })> implements Disposable {
  final LoggerService logger;

  OnboardingAdditionalController({
    required this.logger,
  }) : super(
          (
            avatarUrl: null,
            aboutMe: null,
            status: null,
            location: null,
            dateOfBirth: null,
          ),
        );

  ///
  /// VARIABLES
  ///

  final dateController = TextEditingController();
  final imagePicker = ImagePicker();

  ///
  /// DISPOSE
  ///

  @override
  void onDispose() {
    dateController.dispose();
  }

  ///
  /// METHODS
  ///

  void updateState({
    String? avatarUrl,
    String? aboutMe,
    String? status,
    String? location,
    DateTime? dateOfBirth,
  }) {
    if (avatarUrl != null) {
      final oldValue = value;

      value = (
        avatarUrl: avatarUrl.trim(),
        aboutMe: oldValue.aboutMe,
        status: oldValue.status,
        location: oldValue.location,
        dateOfBirth: oldValue.dateOfBirth,
      );
    }

    if (aboutMe != null) {
      final oldValue = value;

      value = (
        avatarUrl: oldValue.avatarUrl,
        aboutMe: aboutMe.trim(),
        status: oldValue.status,
        location: oldValue.location,
        dateOfBirth: oldValue.dateOfBirth,
      );
    }

    if (status != null) {
      final oldValue = value;

      value = (
        avatarUrl: oldValue.avatarUrl,
        aboutMe: oldValue.aboutMe,
        status: status.trim(),
        location: oldValue.location,
        dateOfBirth: oldValue.dateOfBirth,
      );
    }

    if (location != null) {
      final oldValue = value;

      value = (
        avatarUrl: oldValue.avatarUrl,
        aboutMe: oldValue.aboutMe,
        status: oldValue.status,
        location: location.trim(),
        dateOfBirth: oldValue.dateOfBirth,
      );
    }

    if (dateOfBirth != null) {
      final oldValue = value;

      value = (
        avatarUrl: oldValue.avatarUrl,
        aboutMe: oldValue.aboutMe,
        status: oldValue.status,
        location: oldValue.location,
        dateOfBirth: dateOfBirth,
      );
    }
  }

  void updateDateOfBirth({required DateTime newDate}) {
    final formattedDate = DateFormat(
      'd. MMMM yyyy.',
      'hr',
    ).format(newDate);

    dateController.text = formattedDate;

    updateState(dateOfBirth: newDate);
  }

  Future<void> pickImage() async {
    final image = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 1080,
      maxWidth: 1080,
      imageQuality: 60,
    );

    if (image != null) {
      updateState(
        avatarUrl: image.path,
      );

      logger.f('New image -> ${image.path}');
    } else {
      logger.e('Image not picked');
    }
  }
}
