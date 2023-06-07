import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:template/router.dart';
import 'package:template/template_modules/components/about_dialog_list_tile.dart';
import 'package:template/template_modules/components/custom_dialog.dart';
import 'package:template/template_modules/localization/language_select.dart';
import 'package:template/template_modules/theme/theme_select_list_tile.dart';

import 'flutter_animated_switcher.dart';

final _random = math.Random();

extension<T> on List<T> {
  T random() => this[_random.nextInt(length)];
  T randomNext(T current) {
    if (length == 1) return first;
    while (true) {
      final next = this[_random.nextInt(length)];
      if (next != current) return next;
    }
  }
}

@RoutePage(name: 'ScreenSaverRoute')
class ScreenSaverScreen extends StatefulWidget {
  const ScreenSaverScreen({super.key});

  @override
  State<ScreenSaverScreen> createState() => _ScreenSaverScreenState();
}

class _ScreenSaverScreenState extends State<ScreenSaverScreen> {
  final List<String> leftWords = ["BE", "STAY"];
  final List<String> rightWords = [
    "PERSISTENT",
    "YOURSELF",
    "FOCUSED",
    "PATIENT"
  ];

  late String left = leftWords.first;
  late String right = rightWords.first;
  Timer? updateTimer;

  void resetTimer() {
    updateTimer?.cancel();
    updateTimer = Timer.periodic(
      const Duration(seconds: 15),
      (_) => _next(false),
    );
  }

  void _next([bool manual = true]) async {
    setState(() {
      if (_random.nextBool()) {
        left = leftWords.randomNext(left);
      } else {
        right = rightWords.randomNext(right);
      }
    });
    if (manual) {
      resetTimer();
    }
  }

  @override
  void initState() {
    resetTimer();
    super.initState();
  }

  @override
  void dispose() {
    updateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final backgroundColor = colorScheme.surface;
    final color = colorScheme.onSurface;
    final style = TextStyle(
      fontFamily: 'Fira Code',
      color: color,
      fontWeight: FontWeight.w500,
      fontSize: 56,
    );
    return Scaffold(
      backgroundColor: backgroundColor,
      body: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.enter): _next,
          const SingleActivator(LogicalKeyboardKey.comma, control: true): () {
            showAnimatedDialog(
              context: context,
              child: const _SettingsDialog(),
            );
          },
        },
        child: Focus(
          autofocus: true,
          child: Stack(
            children: [
              Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: FlutterAnimatedSwitcher.fromAnimation(
                        animation: SwitchAnimation.flyUp(),
                        child: Text(
                          left,
                          key: ValueKey('left/$left'),
                          style: style,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        height: 56,
                        width: 4,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Expanded(
                      child: FlutterAnimatedSwitcher.fromAnimation(
                        animation: SwitchAnimation.flyDown(),
                        child: Text(
                          right,
                          key: ValueKey('right/$right'),
                          style: style,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const _Clock(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Clock extends StatefulWidget {
  const _Clock({super.key});

  @override
  State<_Clock> createState() => _ClockState();
}

class _ClockState extends State<_Clock> {
  late final timer = Timer.periodic(
    const Duration(seconds: 1),
    (timer) => setState(() => time = DateTime.now()),
  );

  DateTime time = DateTime.now();

  @override
  void initState() {
    timer;
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final backgroundColor = colorScheme.surface;
    final color = colorScheme.onSurface;
    final style = TextStyle(
      fontFamily: 'Fira Code',
      color: color,
      fontSize: 24,
      fontWeight: FontWeight.w400,
    );
    final format = DateFormat(DateFormat.HOUR24_MINUTE_SECOND);
    final formatedDate = format.format(time);
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // _Weather(),
            Text(
              formatedDate,
              key: ValueKey('time/$time'),
              style: style,
            ),
          ],
        ),
      ),
    );
  }
}

class _Weather extends StatelessWidget {
  const _Weather({super.key});

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontFamily: 'Fira Code ',
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.w400,
    );
    return Text('21 °C', style: style);
  }
}

class _SettingsDialog extends StatelessWidget {
  const _SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDialogPage(
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              onChanged: (_) {},
              value: true,
              title: Text('Show clock'),
            ),
            ListTile(
              title: Text('Word change delay'),
            ),
            ListTile(
              title: Text('word list'),
              trailing: Icon(Icons.text_fields_sharp),
            ),
            // LanguageSelectListTile(),
            ThemeSelectListTile(),
            AboutDialogListTile(),
          ],
        ),
      ),
    );
  }
}