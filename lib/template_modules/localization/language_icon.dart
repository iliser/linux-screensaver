import 'package:flutter/material.dart';

import 'language_select_config.dart';

class LanguageIcon extends StatelessWidget {
  const LanguageIcon({
    super.key,
    this.language,
    this.alignment = Alignment.center,
  });

  final Language? language;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      child: Align(
        alignment: alignment,
        child: language == null
            ? const Icon(Icons.translate)
            : Image.asset(
                'icons/flags/png/${language!.countryCode}.png',
                package: 'country_icons',
              ),
      ),
    );
  }
}
