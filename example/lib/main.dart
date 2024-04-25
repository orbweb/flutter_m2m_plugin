
import 'package:flutter/material.dart';

import 'demo.dart';

void main() {
  runApp(const MyApp());
}

TextStyle textStyle = const TextStyle(
  color: Colors.black87,
  fontSize: 21,
  fontWeight: FontWeight.w400,
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AppPage(),
    );
  }
}

class AppPage extends StatelessWidget {
  const AppPage({super.key});


  void startDemo(BuildContext context) {
    debugPrint('startDemo !!!!');
    Navigator.push(context,
        MaterialPageRoute<void>(builder: (BuildContext context) => const Demo()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Center(
          child: TextButton(
            onPressed: () => startDemo(context),
            child: Text('Start Demo', style: textStyle,),
          ),
        ),
      ),

    );
  }

}

