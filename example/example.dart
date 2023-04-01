import 'package:bloc_notification/bloc_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<CounterCubit>(
        create: (context) => CounterCubit(),
        child: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            BlocNotificationConsumer<CounterCubit, int, PageNotification>(
              notificationListener: (context, notification) {
                if (notification is ShowDialogNotification) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                          title: Text("This is the dialog"),
                        );
                      });
                }
              },
              builder: (context, state) {
                return Text(
                  "$state",
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: context.read<CounterCubit>().increaseCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: context.read<CounterCubit>().showDialog,
            tooltip: 'Show dialog',
            child: const Icon(Icons.notification_add),
          ),
        ],
      ),
    );
  }
}

abstract class PageNotification {
  const PageNotification();
}

class ShowDialogNotification extends PageNotification {
  const ShowDialogNotification();
}

class CounterCubit extends Cubit<int>
    with BlocNotificationMixin<int, PageNotification> {
  CounterCubit() : super(0);

  void increaseCounter() {
    emit(state + 1);
  }

  void showDialog() {
    notify(const ShowDialogNotification());
  }
}
