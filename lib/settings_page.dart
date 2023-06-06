import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajustes'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Volver al inicio'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
