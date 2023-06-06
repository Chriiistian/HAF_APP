import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
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

