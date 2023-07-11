import 'package:flutter/material.dart';

class ProductsManagementPage extends StatefulWidget {
  @override
  _ProductsManagementPageState createState() => _ProductsManagementPageState();
}

class _ProductsManagementPageState extends State<ProductsManagementPage> {
  List<Product> products = [
    Product(id: 1, name: 'Producto 1', price: 10.0, quantity: 5, isInStock: true),
    Product(id: 2, name: 'Producto 2', price: 20.0, quantity: 0, isInStock: false),
    Product(id: 3, name: 'Producto 3', price: 15.0, quantity: 8, isInStock: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Productos'),
      ),
      body: ListView.separated(
        itemCount: products.length,
        separatorBuilder: (context, index) => Divider(height: 1),
        itemBuilder: (context, index) {
          Product product = products[index];
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  child: Icon(Icons.shopping_cart),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name),
                      SizedBox(height: 8),
                      Text('Precio: \$${product.price.toStringAsFixed(2)}'),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                product.isInStock = !product.isInStock;
                                if (product.quantity == 0) {
                                  product.isInStock = false;
                                }
                              });
                            },
                            child: Text(product.isInStock ? 'En stock' : 'Sin stock'),
                            style: ElevatedButton.styleFrom(
                              primary: product.isInStock ? Colors.green : Colors.red,
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            ),
                          ),
                          SizedBox(width: 16),
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                if (product.quantity > 0) {
                                  product.quantity--;
                                  if (product.quantity == 0) {
                                    product.isInStock = false;
                                  }
                                }
                              });
                            },
                          ),
                          Text(
                            product.quantity.toString(),
                            style: TextStyle(fontSize: 18),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                product.quantity++;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Product {
  final int id;
  final String name;
  final double price;
  int quantity;
  bool isInStock;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 0,
    this.isInStock = true,
  });
}
