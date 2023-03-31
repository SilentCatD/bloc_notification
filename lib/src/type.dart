import 'package:flutter/material.dart';

/// Type for `notificationListener` parameter.
typedef BlocWidgetNotificationListener<N> = void Function(
    BuildContext context, N notification);
