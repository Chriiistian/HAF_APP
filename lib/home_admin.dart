import 'package:flutter/material.dart';
import 'package:haf/purchases_history_admin_page.dart';
import 'package:haf/products_management_page.dart';
import 'package:haf/settings_admin_page.dart';

class HomeAdminpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio (Admin)'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 200,
              height: 200,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _navigateToPage(context, PurchasesHistoryAdminPage()),
              child: Text('Historial de Pedidos'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _navigateToPage(context, ProductsManagementPage()),
              child: Text('Gestión de Productos'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToPage(context, SettingsAdminPage()),
        child: Icon(Icons.settings),
      ),
    );
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }
}
