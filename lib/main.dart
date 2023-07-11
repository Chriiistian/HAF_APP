import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_page.dart';
import 'settings_page.dart';
import 'home_page.dart';
import 'home_admin.dart';
import 'purchases_history_page.dart';
import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configuración de las notificaciones
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await FlutterLocalNotificationsPlugin().initialize(initializationSettings);

  runApp(MyApp());
}
int userType = 0;

class MyApp extends StatelessWidget {
  // Verificar el estado de la sesión y obtener el valor de Typeuser
  Future<Map<String, dynamic>> checkSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    userType = prefs.getInt('userType') ?? userType;
    return {'isLoggedIn': isLoggedIn, 'userType': userType};
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: checkSession(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          bool isLoggedIn = snapshot.data!['isLoggedIn'];
          int userType =
              snapshot.data!['userType']!; // Asegurar que el valor no sea null

          Widget homeWidget = isLoggedIn ? HomeAdminpage() : LoginPage();
          if (userType == 1) {
            homeWidget = isLoggedIn ? HomePage() : LoginPage();
          } else if (userType == 2) {
            homeWidget = isLoggedIn ? HomeAdminpage() : LoginPage();
          }

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Mi App',
            theme: ThemeData(
              primarySwatch: Colors.orange,
            ),
            home: homeWidget,
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/profile':
                  return MaterialPageRoute(builder: (_) => ProfilePage());
                case '/settings':
                  return MaterialPageRoute(builder: (_) => SettingsPage());
                case '/purchases':
                  return MaterialPageRoute(builder: (_) => HomeAdminpage());
                case '/purchases_history':
                  return MaterialPageRoute(
                      builder: (_) => PurchasesHistoryPage());
                case '/home_page':
                  return MaterialPageRoute(builder: (_) => HomePage());
                default:
                  return MaterialPageRoute(builder: (_) => ErrorPage());
              }
            },
          );
        } else {
          return CircularProgressIndicator();
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
