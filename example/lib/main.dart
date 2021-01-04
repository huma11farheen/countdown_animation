import 'package:countdown_animation/countdown_animation.dart';
import 'package:disposable_provider/disposable_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class NumberDisplayController extends ChangeNotifier {
  final int totalNumber;
  int _count;

  NumberDisplayController(this.totalNumber) : _count = totalNumber;

  int get count => _count;
  void decrement() {
    _count--;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ' Countdown Animation Demo',
      home: MainPage.wrapped(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key key}) : super(key: key);
  static Widget wrapped() {
    return MultiProvider(
      providers: [
        DisposableProvider(
          create: (context) => CountController(),
        ),
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => NumberDisplayController(10),
        )
      ],
      child: MainPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final count = Provider.of<NumberDisplayController>(context);
    Widget _progressDisplay() {
      return Text(
        context.watch<NumberDisplayController>().count.toString(),
        style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
      );
    }

    return Scaffold(
      appBar: AppBar(),
      body: Stack(children: [
        Center(
          child: Align(
            alignment: Alignment.topLeft,
            child: CountDownAnimation(
              size: Size(90, 90),
              backgroundColor: Colors.grey.withOpacity(0.2),
              progressColor: Colors.red,
              totalDivisions:
              context.watch<NumberDisplayController>().totalNumber,
              controller: context.watch(),
              child: _progressDisplay(),
            ),
          ),
        ),
        Align(
          alignment: Alignment(0, 0.5),
          child: RaisedButton(
            child: Text('Decrement'),
            onPressed: () {
              count.decrement();
              context.read<CountController>().trigger(count.count);
            },
          ),
        )
      ]),
    );
  }
}
