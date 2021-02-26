import 'package:countdown_animation/countdown_animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
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

class MainPage extends StatefulWidget {
  const MainPage({Key key}) : super(key: key);
  static Widget wrapped() {
    return MultiProvider(
      providers: [
        Provider(
          create: (context) => CountTriggerController(),
        ),
        ChangeNotifierProvider(
          lazy: false,
          create: (context) => NumberController(0),
        ),
      ],
      child: MainPage(),
    );
  }

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    int count = context.watch<NumberController>().value;
    Widget _progressDisplay() {
      return Text(
        count.toString(),
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
              operation: Operation.Decrement,
              initialCounterIndex: 0,
              totalNumber: 4,
              size: 90,
              backgroundColor: Colors.grey.withOpacity(0.2),
              progressColor: Colors.red,
              controller: context.watch(),
              child: _progressDisplay(),
              onChanged: (index) {},
            ),
          ),
        ),
        Align(
          alignment: Alignment(0, 0.5),
          child: RaisedButton(
            child: Text('Increment'),
            onPressed: () {
              final count = context.read<NumberController>().value++;
              context.read<CountTriggerController>().trigger(count);
            },
          ),
        )
      ]),
    );
  }
}

class NumberController extends ValueNotifier<int> {
  final int initialIndex;

  NumberController(this.initialIndex) : super(initialIndex);

  void setIndex(int index) {
    value = index;
    notifyListeners();
  }
}
