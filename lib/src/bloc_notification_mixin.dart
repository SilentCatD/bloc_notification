import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import 'bloc_notification.dart';
import 'notification_observer_mixin.dart';

/// The [BlocNotificationMixin] is a Flutter Bloc mixin that provides a simple
/// notification mechanism for handling UI-related actions separately from the
/// state. By using this mixin, you can fire notifications from the `Bloc` and
/// handle them in the UI layer using a callback mechanism,
/// without having to manage them in the state.
///
/// To use the [BlocNotificationMixin], simply import the `flutter_bloc`
/// package, and apply the mixin to your [Bloc] / [Cubit] :
///
/// ```dart
/// class MyBloc extends Bloc<MyEvent, MyState> with BlocNotificationMixin<MyState, MyNotification> {
///   // ...
/// }
/// ```
///
/// The [BlocNotificationMixin] defines a `Stream` of notifications that can be
/// listened to by the UI layer using the notification getter. To fire a
/// notification from the [Bloc] / [Cubit], simply call the notify method with
/// the notification payload:
///
/// ```dart
/// notify(MyNotification(payload));
/// ```
///
/// Where `MyNotification` is a class that represents the notification and
/// payload is the data associated with the notification.
mixin BlocNotificationMixin<State, N> on BlocBase<State> {
  late final _notificationController = StreamController<N>.broadcast();

  /// The notification stream
  Stream<N> get notification => _notificationController.stream;

  /// Whether the notification stream is closed.
  bool get isNotificationClosed => _notificationController.isClosed;

  NotificationObserverMixin? get _observer {
    final observer = Bloc.observer;
    if (observer is NotificationObserverMixin) return observer;
    return null;
  }

  /// Send a notification to listeners, this will call [onNotification] on this
  /// class and optionally on [BlocObserver] if [BlocObserver] implement
  /// [NotificationObserverMixin].
  /// By default, calling notify after it is closed will throw [StateError] and
  /// trigger [onError].
  @protected
  void notify(N notification) {
    try {
      if (isNotificationClosed) {
        throw StateError('Cannot notify new notifications after calling close');
      }
      onNotification(BlocNotification<N>(notification: notification));
      _notificationController.add(notification);
    } catch (error, stackTrace) {
      onError(error, stackTrace);
      rethrow;
    }
  }

  /// Function called when there's new [BlocNotification] fired from [BlocBase]
  @mustCallSuper
  @protected
  void onNotification(BlocNotification<N> blocNotification) {
    // ignore: invalid_use_of_protected_member
    _observer?.onNotification(this, blocNotification);
  }

  @override
  Future<void> close() async {
    await _notificationController.close();
    return super.close();
  }
}
