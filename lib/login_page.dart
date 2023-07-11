import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = '';
  String _password = '';

  @override
  void initState() {
    super.initState();
    checkSession();
  }

  void checkSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/home_page');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar sesión'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Correo electrónico'),
              onChanged: (value) {
                setState(() {
                  _email = value;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Contraseña'),
              onChanged: (value) {
                setState(() {
                  _password = value;
                });
              },
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text('Iniciar sesión'),
              onPressed: () {
                _login();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _login() async {
    // Construye los datos del formulario de inicio de sesión
    Map<String, String> loginData = {
      'email': _email,
      'password': _password,
    };

    // Realiza una solicitud POST a la API con los datos del formulario
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/login'),
      body: json.encode(loginData),
      headers: {'Content-Type': 'application/json'},
    );

    // Verifica el código de respuesta de la API
    if (response.statusCode == 200) {
      // El inicio de sesión fue exitoso
      Map<String, dynamic> responseData = json.decode(response.body);
      Map<String, dynamic> userData = responseData['user'];

      // Accede a los datos del usuario y utilízalos según tus necesidades
      int userId = userData['id'];
      String userName = userData['name'];
      int userType = userData['type_user'];
      String userMail = userData['email'];

      // Guarda los datos del usuario en el almacenamiento local
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', userId);
      await prefs.setString('userName', userName);
      await prefs.setInt('userType', userType);
      await prefs.setString('userMail', userMail);
      await prefs.setBool('isLoggedIn', true);

      // Navega a la siguiente página
      Navigator.pushReplacementNamed(context, '/home_page');
    } else {
      // El inicio de sesión falló
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error de inicio de sesión'),
            content: Text(
                'El inicio de sesión falló. Verifica tus credenciales e intenta nuevamente.'),
            actions: [
              TextButton(
                child: Text('Cerrar'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }
}
