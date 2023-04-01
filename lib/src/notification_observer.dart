import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import 'bloc_notification.dart';

/// Mixin for [BlocObserver] to additionally listen to notification fired from
/// [BlocNotificationMixin]
mixin NotificationObserverMixin on BlocObserver {
  @protected
  @mustCallSuper
  void onNotification(BlocBase bloc, BlocNotification notification) {}
}
