import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

/// The `BlocNotificationMixin` is a Flutter Bloc mixin that provides a simple
/// notification mechanism for handling UI-related actions separately from the
/// state. By using this mixin, you can fire notifications from the `Bloc` and
/// handle them in the UI layer using a callback mechanism,
/// without having to manage them in the state.
///
/// To use the `BlocNotificationMixin`, simply import the `flutter_bloc`
/// package, and apply the mixin to your `Bloc`:
///
/// ```dart
/// class MyBloc extends Bloc<MyEvent, MyState> with BlocNotificationMixin<MyState, MyNotification> {
///   // ...
/// }
/// ```
///
/// The `BlocNotificationMixin` defines a `Stream` of notifications that can be
/// listened to by the UI layer using the notification getter. To fire a
/// notification from the Bloc, simply call the notify method with the
/// notification payload:
///
/// ```dart
/// notify(MyNotification(payload));
/// ```
///
/// Where `MyNotification` is a class that represents the notification and
/// payload is the data associated with the notification.
mixin BlocNotificationMixin<State, N> on BlocBase<State> {
  final _notificationSubject = PublishSubject<N>();

  Stream<N> get notification => _notificationSubject.stream;

  @protected
  void notify(N notification) {
    if (!_notificationSubject.isClosed) {
      _notificationSubject.add(notification);
    }
  }

  @override
  Future<void> close() async {
    await _notificationSubject.close();
    return super.close();
  }
}
