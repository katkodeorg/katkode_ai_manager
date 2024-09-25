import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utilities/constants.dart';

class DialogGetApikey extends StatefulWidget {
  const DialogGetApikey({super.key});

  @override
  State<DialogGetApikey> createState() => _DialogGetApikeyState();
}

class _DialogGetApikeyState extends State<DialogGetApikey> {
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
      child: AlertDialog(
        backgroundColor: Theme.of(context).canvasColor,
        titlePadding: EdgeInsets.zero,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 30.0,
              ),
              const Text(
                'Get Gemini API Key',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff2F2F2F),
                  fontVariations: [
                    FontVariation('wght', 700),
                  ],
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              const SizedBox(
                width: double.infinity,
                child: Text(
                  'Get your key and add it in the settings page to enable Gemini integration.',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Color(0xff2F2F2F),
                    fontVariations: [
                      FontVariation('wght', 400),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () async {
                    Uri geminiUrl = Uri.parse(
                      'https://aistudio.google.com/app/apikey',
                    );
                    await launchUrl(geminiUrl);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: mainButtonColor,
                    disabledBackgroundColor: const Color(0xffC0C0C0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                    ),
                    shadowColor: const Color.fromRGBO(114, 114, 114, 0.45),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Get API Key',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontVariations: [
                        FontVariation('wght', 600),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
      ),
    );
  }
}
