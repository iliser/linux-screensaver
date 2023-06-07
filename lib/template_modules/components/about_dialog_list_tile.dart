import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:template/template_modules/components/custom_dialog.dart';
import 'package:template/globals.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutDialogListTile extends ConsumerWidget {
  const AboutDialogListTile({super.key, this.childrenBuilder});

  // additional childs that can be added after developer section
  final List<Widget> Function(BuildContext context)? childrenBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final T = ref.watch(localizationProvider);
    return ListTile(
      onTap: () => context.router.pushNamed('/settings/about'),
      title: Text(T.aboutDialog.listTitle),
      trailing: const Icon(Icons.info_outline),
    );
  }
}

class _AboutDialog extends ConsumerStatefulWidget {
  const _AboutDialog(this.childrenBuilder);

  final List<Widget> Function(BuildContext context)? childrenBuilder;

  @override
  ConsumerState<_AboutDialog> createState() => __AboutDialogState();
}

class __AboutDialogState extends ConsumerState<_AboutDialog> {
  PackageInfo? packageInfo;

  @override
  void initState() {
    PackageInfo.fromPlatform()
        .then((value) => setState(() => packageInfo = value));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final version = packageInfo?.version ?? '';
    final build = packageInfo?.buildNumber ?? '';
    final title = packageInfo?.appName ?? '';
    final T = ref.watch(localizationProvider);
    return Card(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: Text(title),
            subtitle: Text(
              T.aboutDialog.version(build: build, version: version),
            ),
          ),
          ListTile(
            onTap: () => launchUrl(Uri.parse(T.aboutDialog.developerUrl)),
            title: Row(
              children: [
                Text(T.aboutDialog.developedBy),
                const SizedBox(width: 4),
                Text(
                  T.aboutDialog.developerName,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              ],
            ),
            subtitle: Text(T.aboutDialog.developerSubtitle),
          ),
          ...?widget.childrenBuilder?.call(context),
          ListTile(
            title: Text(T.aboutDialog.licence),
            trailing: const Icon(Icons.navigate_next),
            onTap: () => showLicensePage(context: context),
          ),
        ],
      ),
    );
  }
}

@RoutePage()
class AboutDialogScreen extends StatelessWidget {
  const AboutDialogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomDialogPage(child: _AboutDialog(null));
  }
}
