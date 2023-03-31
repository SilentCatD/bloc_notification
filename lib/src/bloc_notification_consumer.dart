import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_notification_listener.dart';
import 'bloc_notification_mixin.dart';
import 'type.dart';

/// Similar to the `BlocConsumer` widget, the `BlocNotificationConsumer` widget
/// is used to wrap a `BlocNotificationListener` and take a `notificationListener`
/// callback.
///
/// ```dart
/// BlocNotificationConsumer<MyBloc, MyState, MyNotification>(
///   builder: (context, state) {
///     // Build the UI based on the current state
///   },
///   notificationListener: (context, notification) {
///     // Handle the notification
///   },
/// );
/// ```
class BlocNotificationConsumer<B extends BlocNotificationMixin<S, N>, S, N>
    extends StatefulWidget {
  const BlocNotificationConsumer({
    Key? key,
    required this.builder,
    this.listener,
    this.notificationListener,
    this.bloc,
    this.listenWhen,
    this.buildWhen,
  }) : super(key: key);

  final B? bloc;
  final BlocWidgetNotificationListener<N>? notificationListener;
  final BlocWidgetBuilder<S> builder;
  final BlocWidgetListener<S>? listener;
  final BlocBuilderCondition<S>? buildWhen;
  final BlocListenerCondition<S>? listenWhen;

  @override
  State<BlocNotificationConsumer> createState() =>
      _BlocNotificationConsumerState<B, S, N>();
}

class _BlocNotificationConsumerState<B extends BlocNotificationMixin<S, N>, S,
    N> extends State<BlocNotificationConsumer<B, S, N>> {
  late B _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc ?? context.read<B>();
  }

  @override
  void didUpdateWidget(BlocNotificationConsumer<B, S, N> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldBloc = oldWidget.bloc ?? context.read<B>();
    final currentBloc = widget.bloc ?? oldBloc;
    if (oldBloc != currentBloc) _bloc = currentBloc;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bloc = widget.bloc ?? context.read<B>();
    if (_bloc != bloc) _bloc = bloc;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.bloc == null) {
      // Trigger a rebuild if the bloc reference has changed.
      // See https://github.com/felangel/bloc/issues/2127.
      context.select<B, bool>((bloc) => identical(_bloc, bloc));
    }
    return BlocNotificationListener<B, S, N>(
      notificationListener: widget.notificationListener,
      listenWhen: widget.listenWhen,
      listener: widget.listener,
      bloc: _bloc,
      child: BlocBuilder<B, S>(
        bloc: _bloc,
        builder: widget.builder,
        buildWhen: (previous, current) {
          return widget.buildWhen?.call(previous, current) ?? true;
        },
      ),
    );
  }
}
