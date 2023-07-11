import 'package:flutter/material.dart';
import 'settings_page.dart';
import 'login_page.dart';

class SettingsAdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajustes de Administrador'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Página de Ajustes de Administrador'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Lógica para cerrar sesión
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                );
              },
              child: Text('Cerrar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
