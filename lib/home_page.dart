import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final List<String> categories = [
    'Categoría 1',
    'Categoría 2',
    'Categoría 3',
    'Categoría 4',
    'Categoría 5',
  ];

  @override
  Widget build(BuildContext context) {
    Color buttonColor = Color.fromARGB(255, 255, 145, 0); // Color azul claro (#87CEEB)

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Hola Usuario'),
            IconButton(
              icon: ClipOval(
                child: Image.network(
                  'https://img.freepik.com/vector-premium/perfil-hombre-dibujos-animados_18591-58482.jpg?w=2000',
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
            ),
            SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ButtonBar(
                children: categories.map((category) {
                  return ElevatedButton(
                    child: Text(category),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      primary: buttonColor,
                      onPrimary: Colors.white,
                    ),
                    onPressed: () {
                      // Acciones al seleccionar una categoría
                    },
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: Text('Ir al perfil'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      primary: buttonColor,
                      onPrimary: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    child: Text('Ajustes'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      primary: buttonColor,
                      onPrimary: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}




