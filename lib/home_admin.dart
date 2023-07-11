import 'package:flutter/material.dart';
import 'package:haf/purchases_history_page.dart';
import 'package:haf/products_management_page.dart';
import 'package:haf/settings_admin_page.dart';

class HomeAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio (Admin)'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/logo.png', // Ruta de la imagen (ajusta la ruta según la ubicación de tu imagen)
            width: 200, // Ancho de la imagen
            height: 200, // Alto de la imagen
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PurchasesHistoryPage()),
              );
            },
            child: Text('Historial de Pedidos'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProductsManagementPage()),
              );
            },
            child: Text('Gestión de Productos'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => SettingsAdminPage()),
          );
        },
        child: Icon(Icons.settings),
      ),
    );
  }
}