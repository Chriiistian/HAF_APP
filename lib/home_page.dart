import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'settings_page.dart';
import 'SuccessPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';

class Item {
  final String id;
  final String name;
  final double price;
  int quantity;
  bool isSelected;

  Item({
    required this.id,
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
    loadItemsFromAPI();
  }

  int userId = 0;

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonData =
        await DefaultAssetBundle.of(context).loadString('assets/data.json');
    final data = json.decode(jsonData);
    setState(() {
      username = prefs.getString('userName') ?? data['usuario']['nombre'];
      userImageUrl = data['usuario']['fotoPerfil'];
      userId = prefs.getInt('userId') ?? userId; // Agregar la variable userId
      categorias = List<Map<String, dynamic>>.from(data['categorias']);
      preferencias = List<Map<String, dynamic>>.from(data['preferencias']);
    });
  }

  Future<void> loadItemsFromAPI() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/items'));

    if (response.statusCode == 200) {
      final dynamic jsonResponse = json.decode(response.body);

      if (jsonResponse is List) {
        setState(() {
          items = jsonResponse
              .map((item) => Item(
                    id: item['id'].toString(),
                    name: item['name'] ?? '',
                    price: double.parse(item['price'].toString()),
                  ))
              .toList();
        });
      } else {
        print('Invalid response format: $jsonResponse');
      }
    } else {
      print('Error en la solicitud GET: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
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
        title: Text(item.name, style: TextStyle(fontSize: 22)),
        subtitle: Text(
          "\$${item.price}",
          style: TextStyle(fontSize: 22),
        ),
        trailing:
            Text("Unidades: ${item.quantity}", style: TextStyle(fontSize: 22)),
      );
    }).toList();
  }

  String getTotalAmount() {
    double totalAmount = 0;
    for (var item in selectedItems) {
      int quantity = item.quantity;
      double price = item.price; // Convert the string price to double
      totalAmount += quantity * price;
    }
    return totalAmount.toStringAsFixed(2);
  }

  Future<void> comprarItems(List<Item> items) async {
    // Crear la fecha actual
    DateTime now = DateTime.now();
    String fecha = now.toString();

    // Crear la lista de órdenes de compra
    List<Map<String, dynamic>> ordenesCompra = [];

    for (Item item in items) {
      Map<String, dynamic> ordenCompra = {
        'id_user': userId,
        'id_item': item.id,
        'fecha': fecha,
        'valor': item.price * item.quantity,
      };
      ordenesCompra.add(ordenCompra);
    }

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/ordenes'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(ordenesCompra),
    );

    if (response.statusCode == 200) {
      Showsuccesspay();
      // Las órdenes de compra se crearon exitosamente
      print('Órdenes de compra creadas');
      selectedItems.clear();
    } else {
      // Hubo un error al crear las órdenes de compra
      print('Error al crear las órdenes de compra');
    }
  }

  void Showsuccesspay() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SuccessPage(
          message: 'La compra se realizó exitosamente.',
          gifUrl: 'URL_DEL_GIF_AQUÍ',
        ),
      ),
    );
  }

  void showPaymentOptions() {
    int selectedOptionId = 0; // ID de la opción seleccionada

    // Lista de opciones de métodos de pago
    List<Map<String, dynamic>> paymentOptions = [
      {
        'id': 1,
        'title': 'Tarjeta de crédito',
        'image':
            'assets/images/tarjeta_credito.png', // Ruta de la imagen para la opción de tarjeta de crédito
      },
      {
        'id': 2,
        'title': 'PayPal',
        'image':
            'assets/images/paypal.png', // Ruta de la imagen para la opción de PayPal
      },
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Selecciona un método de pago"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: paymentOptions.map((option) {
                  return Column(
                    children: [
                      Image.asset(
                        option['image'],
                        height: 50,
                      ),
                      RadioListTile(
                        title: Text(
                          option['title'],
                          style: TextStyle(fontSize: 18),
                        ),
                        value: option['id'],
                        groupValue: selectedOptionId,
                        onChanged: (value) {
                          setState(() {
                            selectedOptionId = value;
                          });
                        },
                      ),
                    ],
                  );
                }).toList(),
              );
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true)
                    .pop(); // Cerrar el diálogo
                createOrder();
              },
              child: Text("Realizar compra"),
            ),
          ],
        );
      },
    );
  }

  void createOrder() async {
    List<Map<String, dynamic>> ordenesCompra = [];

    for (Item item in selectedItems) {
      DateTime fecha = DateTime.now();

      Map<String, dynamic> ordenCompra = {
        'valor': item.price * item.quantity,
        'id_item': item.id,
        'fecha': fecha.toIso8601String(), // Convert DateTime to string
        'id_user': userId,
      };

      ordenesCompra.add(ordenCompra);
    }

    final response = await http.post(
      Uri.parse(
          'http://10.0.2.2:8000/ordenes'), // Reemplazar con la URL correcta de tu servidor
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(ordenesCompra),
    );

    if (response.statusCode == 200) {
      // Las órdenes de compra se crearon exitosamente
      print('Órdenes de compra creadas');
      selectedItems
          .clear(); // Limpiar la lista de ítems seleccionados después de la compra
    } else {
      // Hubo un error al crear las órdenes de compra
      print('Error al crear las órdenes de compra');
    }
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
            height: 50, // Tamaño vertical para categorías
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
                      child: Text(
                        categoria['title'],
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight
                                .normal), // Tamaño de fuente ajustable
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20), // Bordes redondeados
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
            height: 250,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: preferencias.map((preferencia) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Flexible(
                      child: Container(
                        width: 180,
                        height:
                            220, // Ajusta la altura del contenedor según sea necesario
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
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
                                  style: TextStyle(
                                      fontSize:
                                          20), // Aumenta el tamaño de fuente según sea necesario
                                ),
                              ),
                            ),
                          ],
                        ),
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
                    borderRadius:
                        BorderRadius.circular(10), // Agregar bordes redondeados
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
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                    subtitle: Expanded(
                      child: Text(
                        "\$${item.price}",
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () => decrementQuantity(index),
                        ),
                        Text(
                          item.quantity.toString(),
                          style: TextStyle(fontSize: 22),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => incrementQuantity(index),
                        ),
                        Container(
                          width: 120,
                          height: 60,
                          child: TextButton(
                            onPressed: () => toggleSelection(index),
                            child: Text(
                              item.isSelected ? "Quitar" : "Agregar",
                              style: TextStyle(
                                fontSize: 20, // Tamaño del texto de los botones
                                color: Colors.white,
                              ),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                item.isSelected
                                    ? Color.fromRGBO(133, 43, 43, 1)
                                    : Colors.orange,
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
                            onPressed: () => showPaymentOptions(),
                            child: Text(
                              "Comprar",
                              style: TextStyle(fontSize: 24),
                            ),
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
