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
          create: (context) => CountController(totalNumber: 10),
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
    int count = context.watch<CountController>().currentValue;
    Widget _progressDisplay() {
      return Text(
        context.watch<CountController>().currentValue.toString(),
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
              setState(() {
                count--;
                context.read<CountController>().trigger(count);
              });
            },
          ),
        )
      ]),
    );
  }
}
