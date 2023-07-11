import 'package:flutter/material.dart';

class ProductsManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Productos'),
      ),
      body: Center(
        child: Text('Página de Gestión de Productos'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Acciones al presionar el botón de agregar producto
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
