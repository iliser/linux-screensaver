import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template/modules/screensaver_config/screensaver_config.dart';
import 'package:template/modules/screensaver_config/screensaver_config.provider.dart';
import 'package:template/template_modules/guards/guard.dart';
import 'package:template/template_modules/localization/language_provider.dart';

@RoutePage()
class WordListSettingsScreen extends GuardedScreen {
  const WordListSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(localizationProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings.editWordList),
      ),
      body: const SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _WordList(isRight: false),
            _WordList(isRight: true),
          ],
        ),
      ),
    );
  }

  @override
  List<ScreenGuard> get guards => [
        AsyncGuard([screensaverConfigProvider])
      ];
}

class _WordList extends ConsumerStatefulWidget {
  const _WordList({
    super.key,
    required this.isRight,
  });

  final bool isRight;

  @override
  ConsumerState<_WordList> createState() => _WordListState();
}

class _WordListState extends ConsumerState<_WordList> {
  ScreensaverConfig get _config =>
      ref.read(screensaverConfigProvider).requireValue;

  AsyncValue<ScreensaverConfig> Function(
    ScreensaverConfig Function(ScreensaverConfig value) update,
  ) get _update => ref.read(screensaverConfigProvider.notifier).update;

  late final controller = TextEditingController(
    text: (widget.isRight ? _config.rightWords : _config.leftWords).join('\n'),
  );

  @override
  void initState() {
    controller.addListener(() {
      final words = controller.text.split('\n');

      _update(
        (v) => widget.isRight
            ? v.copyWith(rightWords: words)
            : v.copyWith(leftWords: words),
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: controller,
          maxLines: 300,
          decoration: const InputDecoration(
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
        ),
      ),
    );
  }
}
