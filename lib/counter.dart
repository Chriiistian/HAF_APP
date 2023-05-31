import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  const Counter({Key? key}) : super(key: key);

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _count = 0;

  void _incrementCount() {
    setState(() {
      _count++;
    });
  }

  void _decrementCount() {
    setState(() {
      if (_count > 0) {
        _count--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: _decrementCount,
          icon: Icon(Icons.remove),
        ),
        Text(
          '$_count',
          style: TextStyle(fontSize: 16),
        ),
        IconButton(
          onPressed: _incrementCount,
          icon: Icon(Icons.add),
        ),
      ],
    );
  }
}
