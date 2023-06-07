import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template/template_modules/guards/guards/http_guard.dart';
import 'package:template/template_modules/network/error/http_exception.dart';
import 'package:template/template_modules/network/error/network_exceptions.dart';

class GuardedHttpErrorWidget extends StatelessWidget {
  const GuardedHttpErrorWidget(this.error, {Key? key}) : super(key: key);

  final NetworkException error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DefaultTextStyle(
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              child: error.widget,
            ),
            const SizedBox(height: 8),
            Text(
              error.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).errorColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              error.errorDescription,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class HttpCatErrorWidget extends StatelessWidget {
  const HttpCatErrorWidget(this.error, {super.key});

  final NetworkException error;

  @override
  Widget build(BuildContext context) {
    if (error is HttpException) {
      return Center(
        // TODO use cached network image
        child: Image.network(
          'https://http.cat/${(error as HttpException).code}',
        ),
      );
    }
    return GuardedHttpErrorWidget(error);
  }
}

// Widget that fetch http error config and display properly error widget
class GuardedHttpError extends ConsumerWidget {
  const GuardedHttpError(this.error, {super.key});

  final NetworkException error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = GuardedConfigurationHttpErrorWidget.watch(ref);
    if (config != null) return config.errorWidget(error);

    return GuardedHttpErrorWidget(error);
  }
}
