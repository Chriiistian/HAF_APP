import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'settings_page.dart';
import 'home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => HomePage());
          case '/profile':
            return MaterialPageRoute(builder: (_) => ProfilePage());
          case '/settings':
            return MaterialPageRoute(builder: (_) => SettingsPage());
          default:
            return MaterialPageRoute(builder: (_) => ErrorPage());
        }
      },
    );
  }
}

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error'),
      ),
      body: Center(
        child: Text('Página no encontrada'),
      ),
    );
  }
}

