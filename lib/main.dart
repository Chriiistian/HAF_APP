import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'profile_page.dart';
import 'settings_page.dart';
import 'home_page.dart';
import 'purchases_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configuración de las notificaciones
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await FlutterLocalNotificationsPlugin().initialize(initializationSettings);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mi App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
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
          case '/purchases':
            return MaterialPageRoute(builder: (_) => PurchasesPage());
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
