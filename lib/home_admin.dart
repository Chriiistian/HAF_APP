import 'package:flutter/material.dart';

class HomeAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleccionar Método de Compra'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Lógica para seleccionar el método de compra con Junaeb
                // Puedes agregar aquí la navegación a la siguiente página o la lógica adicional para Junaeb
              },
              child: Text('Pago con Junaeb'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Lógica para seleccionar el método de compra con WebPay
                // Puedes agregar aquí la navegación a la siguiente página o la lógica adicional para WebPay
              },
              child: Text('Pago con WebPay'),
            ),
          ],
        ),
      ),
    );
  }
}