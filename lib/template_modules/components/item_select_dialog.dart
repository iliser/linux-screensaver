import 'package:flutter/material.dart';
import 'package:template/template_modules/components/custom_dialog.dart';

Future<T?> showItemSelectDialog<T>({
  required BuildContext context,
  // prefer the ListTile widget to child
  required Widget Function(T item) itemBuilder,
  required List<T> items,
}) {
  FocusScope.of(context).unfocus();
  return showAnimatedDialog(
    context: context,
    child: Card(
      color: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Builder(
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: items.map(itemBuilder).toList(),
        ),
      ),
    ),
  );
}
