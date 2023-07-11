import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userData;
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();

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

  void changePassword() async {
    String currentPassword = currentPasswordController.text;
    String newPassword = newPasswordController.text;
    String confirmNewPassword = confirmNewPasswordController.text;

    // Obtener el ID de usuario del almacenamiento local
    int userId = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId') ?? userId;

    // Realizar la petición a la API para cambiar la contraseña
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/change_password'),
        body: json.encode({
          'user_id': userId,
          'current_password': currentPassword,
          'new_password': newPassword,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Éxito'),
              content: Text('La contraseña ha sido cambiada exitosamente.'),
              actions: [
                TextButton(
                  child: Text('Aceptar'),
                  onPressed: () {
                    // Limpiar los campos de entrada de contraseña
                    currentPasswordController.clear();
                    newPasswordController.clear();
                    confirmNewPasswordController.clear();

                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(
                  'Hubo un error al cambiar la contraseña. Por favor, inténtalo nuevamente.'),
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
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
                'Hubo un error al cambiar la contraseña. Por favor, inténtalo nuevamente.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                userData != null
                    ? CircleAvatar(
                        backgroundImage:
                            NetworkImage(userData!['usuario']['fotoPerfil']),
                        radius: 50,
                      )
                    : CircularProgressIndicator(),
                SizedBox(width: 16),
                userData != null
                    ? Text(
                        userData!['usuario']['nombre'],
                        style: TextStyle(fontSize: 24),
                      )
                    : CircularProgressIndicator(),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Cambio de contraseña',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña actual',
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Nueva contraseña',
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: confirmNewPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirmar nueva contraseña',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text('Cambiar contraseña'),
              onPressed: changePassword,
            ),
          ],
        ),
      ),
    );
  }
  
  NetworkImage(param0) {}
}

