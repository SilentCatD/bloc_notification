import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';

import 'bloc_notification_mixin.dart';
import 'type.dart';

/// The `BlocNotificationListener` is a widget that listens for notifications
/// from a `Bloc` that uses the `BlocNotificationMixin`, and passes them to a
/// callback provided by the user. This widget is similar to the `BlocListener`
/// widget, but is specialized for handling notifications that are not tied to
/// the state.
///
/// To use the `BlocNotificationListener`, simply create an instance of the
/// widget and provide a callback to handle the notifications. You can also
/// provide an optional `BlocWidgetListener` to handle state changes,
/// a `BlocListenerCondition` to conditionally listen to state changes, and a
/// child widget to render below the `BlocNotificationListener`.
///
/// ```dart
/// BlocNotificationListener<MyBloc, MyState, MyNotification>(
///   notificationListener: (context, notification) {
///     // Handle the notification
///  },
/// );
/// ```
class BlocNotificationListener<B extends BlocNotificationMixin<S, N>, S, N>
    extends SingleChildStatefulWidget {
  final BlocWidgetNotificationListener<N>? notificationListener;
  final BlocWidgetListener<S>? listener;
  final BlocListenerCondition<S>? listenWhen;
  final B? bloc;
  final Widget? child;

  const BlocNotificationListener({
    super.key,
    this.notificationListener,
    this.listener,
    this.listenWhen,
    this.bloc,
    this.child,
  });

  @override
  State<StatefulWidget> createState() =>
      _StateNotificationListenerState<B, S, N>();
}

class _StateNotificationListenerState<B extends BlocNotificationMixin<S, N>, S,
    N> extends SingleChildState<BlocNotificationListener<B, S, N>> {
  StreamSubscription<S>? _subscription;
  StreamSubscription<N>? _notificationSubscription;
  late B _bloc;
  late S _previousState;

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc ?? context.read<B>();
    _previousState = _bloc.state;
    _subscribe();
  }

  @override
  void didUpdateWidget(BlocNotificationListener<B, S, N> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldBloc = oldWidget.bloc ?? context.read<B>();
    final currentBloc = widget.bloc ?? oldBloc;
    if (oldBloc != currentBloc) {
      if (_subscription != null) {
        _unsubscribe();
        _bloc = currentBloc;
        _previousState = _bloc.state;
      }
      _subscribe();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bloc = widget.bloc ?? context.read<B>();
    if (_bloc != bloc) {
      if (_subscription != null) {
        _unsubscribe();
        _bloc = bloc;
        _previousState = _bloc.state;
      }
      _subscribe();
    }
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    assert(
      child != null,
      '''${widget.runtimeType} used outside of MultiBlocListener must specify a child''',
    );
    if (widget.bloc == null) {
      // Trigger a rebuild if the bloc reference has changed.
      // See https://github.com/felangel/bloc/issues/2127.
      context.select<B, bool>((bloc) => identical(_bloc, bloc));
    }
    return child!;
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    _subscription = _bloc.stream.listen((state) {
      if (widget.listenWhen?.call(_previousState, state) ?? true) {
        widget.listener?.call(context, state);
      }
      _previousState = state;
    });
    _notificationSubscription = _bloc.notification.listen((notification) {
      widget.notificationListener?.call(context, notification);
    });
  }

  void _unsubscribe() {
    _subscription?.cancel();
    _notificationSubscription?.cancel();
    _subscription = null;
    _notificationSubscription = null;
  }
}
