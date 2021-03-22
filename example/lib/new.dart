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
      home: New.wrapped(),
    );
  }
}

class New extends StatefulWidget {
  const New({Key key}) : super(key: key);
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
      child: New(),
    );
  }

  @override
  _NewState createState() => _NewState();
}

class _NewState extends State<New> with TickerProviderStateMixin {
  PageController _controller;
  @override
  void initState() {
    final initialPage = context.read<NumberController>().value;
    _controller =
        PageController(initialPage: initialPage, viewportFraction: 0.8);
    super.initState();
  }

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
      body: Column(children: [
        Expanded(
          child: PageView(
            controller: _controller,
            children: [
              Con(),
              Con(),
              Con(),
              Con(),
              Con(),
              Con(),
            ],
            onPageChanged: (number) {
              context.read<CountTriggerController>().trigger(number);
            },
          ),
        ),
        Center(
          child: Align(
            alignment: Alignment.topLeft,
            child: CountDownAnimation(
              operation: Operation.IncrementAndDecrement,
              initialCounterIndex: 0,
              totalNumber: 5,
              size: 90,
              backgroundColor: Colors.grey.withOpacity(0.2),
              progressColor: Colors.red,
              controller: context.watch(),
              child: _progressDisplay(),
              onChanged: context.watch<NumberController>().setIndex,
            ),
          ),
        ),
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

class Con extends StatelessWidget {
  const Con({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(8),
        child: Container(
          color: Colors.red,
        ));
  }
}
