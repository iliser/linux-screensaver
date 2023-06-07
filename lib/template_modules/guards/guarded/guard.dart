import 'package:guarded_core/guarded_core.dart';

abstract class WidgetGuard {
  GuardBase get widgetGuard;
}

abstract class ScreenGuard {
  GuardBase get screenGuard;
}

abstract class Guard implements GuardBase, ScreenGuard, WidgetGuard {
  @override
  GuardBase get screenGuard => this;
  @override
  GuardBase get widgetGuard => this;
}
