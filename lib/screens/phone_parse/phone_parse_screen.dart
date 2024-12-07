import 'package:flutter/material.dart';

import '../../dependencies.dart';
import '../../services/logger_service.dart';
import 'phone_parse_controller.dart';

class PhoneParseScreen extends StatefulWidget {
  @override
  State<PhoneParseScreen> createState() => _PhoneParseScreenState();
}

class _PhoneParseScreenState extends State<PhoneParseScreen> {
  @override
  void initState() {
    super.initState();

    registerIfNotInitialized<PhoneParseController>(
      () => PhoneParseController(
        logger: getIt.get<LoggerService>(),
      ),
      afterRegister: (controller) => controller.init(),
    );
  }

  @override
  void dispose() {
    getIt.unregister<PhoneParseController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = getIt.get<PhoneParseController>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ///
              /// HEADER IMAGE
              ///
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.numbers_rounded,
                      size: 200,
                      color: Colors.indigo,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Phone number parsing'.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              ///
              /// CONTENT
              ///
              Column(
                children: [
                  TextField(
                    controller: controller.phoneNumberController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter phone number',
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => controller.triggerPhoneNumbersParser(
                      controller.phoneNumberController.text.trim(),
                      context: context,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigoAccent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(
                        double.infinity,
                        48,
                      ),
                    ),
                    child: Text(
                      'PhoneNumbersParser'.toUpperCase(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => controller.triggerFlutterLibPhoneNumber(
                      controller.phoneNumberController.text.trim(),
                      context: context,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(
                        double.infinity,
                        48,
                      ),
                    ),
                    child: Text(
                      'LibPhoneNumber'.toUpperCase(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'LibPhoneNumber seems better',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
