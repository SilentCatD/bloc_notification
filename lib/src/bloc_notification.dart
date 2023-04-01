import 'package:meta/meta.dart';

/// Class contain notification fired from [BlocNotificationMixin]
@immutable
class BlocNotification<N> {
  final N notification;

  const BlocNotification({required this.notification});

  @override
  String toString() {
    return 'BlocNotification { notification: $notification }';
  }
}
