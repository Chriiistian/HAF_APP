import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'settings_page.dart';

class Item {
  final String name;
  final String price;
  int quantity;
  bool isSelected;

  Item({
    required this.name,
    required this.price,
    this.quantity = 0,
    this.isSelected = false,
  });
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = "";
  String userImageUrl = "";
  List<Map<String, dynamic>> categorias = [];
  List<Map<String, dynamic>> preferencias = [];
  List<Item> items = [];
  List<Item> selectedItems = [];

  @override
  void initState() {
    super.initState();
    loadUserData();
    loadItems();
  }

  Future<void> loadUserData() async {
    String jsonData = await rootBundle.loadString('assets/data.json');
    final data = json.decode(jsonData);
    setState(() {
      username = data['usuario']['nombre'];
      userImageUrl = data['usuario']['fotoPerfil'];
      categorias = List<Map<String, dynamic>>.from(data['categorias']);
      preferencias = List<Map<String, dynamic>>.from(data['preferencias']);
    });
  }

  void loadItems() async {
    String jsonData = await rootBundle.loadString('assets/data.json');
    final data = json.decode(jsonData);
    final itemsData = List<Map<String, dynamic>>.from(data['items']);
    items = itemsData.map((itemData) {
      return Item(
        name: itemData['name'],
        price: itemData['price'],
      );
    }).toList();
  }

  void incrementQuantity(int index) {
    setState(() {
      items[index].quantity++;
    });
  }

  void decrementQuantity(int index) {
    setState(() {
      if (items[index].quantity > 0) {
        items[index].quantity--;
      }
    });
  }

  void toggleSelection(int index) {
    setState(() {
      items[index].isSelected = !items[index].isSelected;
      if (items[index].isSelected) {
        selectedItems.add(items[index]);
      } else {
        selectedItems.remove(items[index]);
      }
    });
  }

  List<Widget> buildSelectedItemsList() {
    return selectedItems.map((item) {
      return ListTile(
        title: Text(item.name),
        subtitle: Text("\$${item.price}"),
        trailing: Text("Unidades: ${item.quantity}"),
      );
    }).toList();
  }

  String getTotalAmount() {
    int totalAmount = 0;
    for (var item in selectedItems) {
      int quantity = item.quantity;
      int price = int.tryParse(item.price) ?? 0;
      totalAmount += quantity * price;
    }
    return totalAmount.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Hola $username'),
            SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SettingsPage()),
                );
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(userImageUrl),
              ),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 16),
          Container(
            height: 100, // Tamaño vertical para categorías
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categorias.map((categoria) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        // Acción al presionar el botón de categoría
                      },
                      child: Text(categoria['title']),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // Bordes redondeados
                        ),
                        elevation: 2, // Elevación de la sombra
                        shadowColor: Colors.grey, // Color de la sombra
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(height: 16),
          Container(
            height: 200, // Tamaño vertical para preferencias
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: preferencias.map((preferencia) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      width: 120, // Tamaño fijo para cada ítem de preferencia
                      decoration: BoxDecoration(
                        color: Colors.orange, // Color de fondo predeterminado
                        borderRadius: BorderRadius.circular(20), // Bordes redondeados
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey, // Color de la sombra
                            offset: Offset(0, 2), // Desplazamiento de la sombra
                            blurRadius: 4, // Radio del desenfoque de la sombra
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20), // Bordes redondeados
                            child: Image.network(
                              preferencia['image'],
                              height: 165,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                preferencia['title'],
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                Item item = items[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10), // Agregar bordes redondeados
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  padding: EdgeInsets.all(8),
                  child: ListTile(
                    title: Expanded(
                      child: Text(
                        item.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    subtitle: Expanded(
                      child: Text(
                        "\$${item.price}",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () => decrementQuantity(index),
                        ),
                        Text(item.quantity.toString()),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => incrementQuantity(index),
                        ),
                        Container(
                          width: 100,
                          child: TextButton(
                            onPressed: () => toggleSelection(index),
                            child: Text(
                              item.isSelected ? "Quitar" : "Agregar",
                              style: TextStyle(
                                fontSize: 18, // Tamaño del texto de los botones
                                color: Colors.white,
                              ),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                item.isSelected ? Color.fromRGBO(133, 43, 43, 1) : Colors.orange,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: selectedItems.isNotEmpty
          ? FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Carrito de Compra",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          Expanded(
                            child: ListView(
                              children: buildSelectedItemsList(),
                            ),
                          ),
                          Divider(),
                          Text(
                            "Monto total a pagar: \$${getTotalAmount()}",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              // Acción al presionar el botón de compra
                            },
                            child: Text("Comprar"),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Icon(Icons.shopping_cart, size: 42),
            )
          : null,
    );
  }
}











