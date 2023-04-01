[![pub package](https://img.shields.io/pub/v/bloc_notification?color=green&include_prereleases&style=plastic)](https://pub.dev/packages/bloc_notification)

The `bloc_notification` package provides a mixin that separates the mechanism of responding to an
action dispatched by a Flutter Bloc from the state. While using the bloc library, you may find that
certain types of actions need to be handled in the UI layer, such as showing a dialog or navigating
to another screen. When used together with `BlocListener`, managing these actions and the data
associated with them can become burdensome.

For example, if you have a flag variable in the state that notifies the application to show a
dialog, you would need to turn off that flag when the dialog is completed. While this approach may
be necessary in some cases, it can be troublesome to manage these flags for every action.

To simplify the management of these UI-related actions, the `bloc_notification` package provides a
simple notification mechanism that is fired from the Bloc and handled by the UI layer. These
notifications are not tied to the current state and rely on a simple stream-callback mechanism. This
approach can help reduce the complexity of managing UI-related actions in the application.

To use the `bloc_notification` package, simply import the mixin and apply it to your Bloc. Then, you
can define and dispatch actions as usual, while handling UI-related actions separately in the UI
layer using the provided callback mechanism.

## Features

- `BlocNotificationMixin`: A mixin that allows you to send notifications from a bloc to the UI layer.
- `BlocNotificationListener`: A widget that listens to notifications sent by the `BlocNotificationMixin`.
- `BlocNotificationConsumer`: A widget that listens to notifications sent by the `BlocNotificationMixin` 
and rebuilds the UI in response.
- `NotificationObserver`: mixin to be used with `BlocObserver` to additionally listen to notification.
- Easy migration: easily add features through multiple mixins, no extends needed.
- Compatibility: compatible with both `Bloc` and `Cubit`.


## Usage

### BlocNotificationMixin

The `BlocNotificationMixin` provides a way to notify the UI of certain events through a callback
mechanism. You can use it like this:

```dart
class MyBloc extends Bloc<MyEvent, MyState> with BlocNotificationMixin<MyState, MyNotification> {

  void performAction() {
    // ...
    notify(MyNotification());
  }

  @override
  void onNotification(BlocNotification<MyNotification> blocNotification) {
    // response to notification
  }
}
```

The `MyNotification` class can be any data structure, for example:

```dart
abstract class Notification {}

class ShowDialogNotification extends Notification {
  ShowDialogNotification(this.message);

  final String message;
}

class NavigateToPageNotification extends Notification {
  NavigateToPageNotification(this.pageName);

  final String pageName;
}
```

### BlocNotificationListener

The `BlocNotificationListener` is similar to the `BlocListener` widget, but it listens for
notifications beside state changes. You can use it like this:

```dart
BlocNotificationListener<MyBloc, MyState, MyNotification>(
  notificationListener: (BuildContext context, MyNotification notification) {
    // Handle the notification here.
  },
  child: MyWidget(),
);
```

### BlocNotificationConsumer

The `BlocNotificationConsumer` is similar to the BlocConsumer widget, but it listens for
notifications beside state changes. You can use it like this:

```dart
BlocNotificationConsumer<MyBloc, MyState, MyNotification>(
  notificationListener: (BuildContext context, MyNotification notification) {
    // ..
  },
  builder: (BuildContext context, MyState state) {
    // Build your widget here.
  },
);
```

### NotificationObserver

Easily observer notifications fired from bloc/ cubit with simple act of mixin the existed `BlocObserver` 

```dart
class MyObserver extends BlocObserver with NotificationObserver{
  
  @override
  void onNotification(BlocBase bloc, BlocNotification notification) {
    // ..
  }
}
```

## License

This package is licensed under the MIT License. See the LICENSE file for details.



