import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'profile_page.dart';
import 'purchases_history_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonData = await rootBundle.loadString('assets/data.json');
    setState(() {
      userData = json.decode(jsonData);
      userData!['usuario']['nombre'] =
          prefs.getString('userName') ?? userData!['usuario']['nombre'];
      userData!['usuario']['fotoPerfil'] =
          prefs.getString('userImageUrl') ?? userData!['usuario']['fotoPerfil'];
    });
  }

  void logout() async {
    // Borra la información de la sesión en el almacenamiento local
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    // Navega a la página de inicio de sesión
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => LoginPage()));
  }

  void navigateToPage(String pageName) {
    if (pageName == 'ProfilePage') {
      // Redireccionar a la página ProfilePage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(),
        ),
      );
    } else if (pageName == 'PurchasesPage') {
      // Redireccionar a la página PurchasesPage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PurchasesHistoryPage(),
        ),
      );
    } else {
      // Mostrar mensaje de página en desarrollo
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Página no disponible'),
            content: Text('Esta página aún está en desarrollo.'),
            actions: [
              TextButton(
                child: Text('Aceptar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Widget buildButtonWithIcon(String text, IconData icon, Function() onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.symmetric(vertical: 16),
        ),
        textStyle: MaterialStateProperty.all<TextStyle>(
          TextStyle(fontSize: 18, color: Colors.white),
        ),
        minimumSize: MaterialStateProperty.all<Size>(
          Size(double.infinity, 0),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        elevation: MaterialStateProperty.all<double>(5),
        shadowColor: MaterialStateProperty.all<Color>(Colors.grey),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                text,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajustes'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                userData != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          /*CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                                userData!['usuario']['fotoPerfil']),
                          ),*/
                          SizedBox(height: 20),
                          Text(
                            userData!['usuario']['nombre'],
                            style: TextStyle(fontSize: 24, color: Colors.black),
                          ),
                          SizedBox(height: 10),
                          Text(
                            userData!['usuario']['correo'],
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          SizedBox(height: 20),
                          buildButtonWithIcon(
                            'Perfil',
                            Icons.person,
                            () => navigateToPage('ProfilePage'),
                          ),
                          SizedBox(height: 10),
                          buildButtonWithIcon(
                            'Mis compras',
                            Icons.shopping_cart,
                            () => navigateToPage('PurchasesPage'),
                          ),
                          SizedBox(height: 10),
                          buildButtonWithIcon(
                            'Cerrar sesión',
                            Icons.logout,
                            () =>
                                logout(), // Utiliza la función logout para cerrar la sesión
                          ),
                        ],
                      )
                    : CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
}

