import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blueGrey,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _titles = [
    // Inserte aquí los nombres de los artículos para cada card
    'Papas Lays',
    'Ramitas Evercrisp',
    'Amburguesa',
    'Ave Mayo',
    'Completo Italiano',
    'Empanadas de pino',
    'Empanadas de pollo',
    'Chaparritas',
    'Bebida Pepsi',
    'Bebida CocaCola',
    'Bebida Pap',
    'Bibida Bilz',
  ];

  final List<double> _prices = [
    // Inserte aquí los precios de los artículos para cada card
    800,
    780,
    2200,
    2100,
    1500,
    1300,
    1300,
    1200,
    1000,
    1000,
    850,
    850,
  ];

  final List<String> _imageUrls = [
    // Inserte aquí las URLs de las imágenes para cada card
    'https://cugat.cl/multi/losangeles/wp-content/uploads/sites/11/2022/07/7802000014703-2.jpg',
    'https://jumbo.vtexassets.com/arquivos/ids/436113/1841892-02_87070.jpg?v=637569546277900000',
    'https://cdn0.recetasgratis.net/es/posts/0/8/9/pan_para_hamburguesa_28980_600_square.jpg',
    'https://tofuu.getjusto.com/orioneat-prod-resized/eqJgoeBEMy4Zjsxto-1200-1200.webp',
    'https://media-front.elmostrador.cl/2021/05/completo-700x433.jpg',
    'https://www.planetamama.com.ar/sites/default/files/styles/medium/public/2019-08/empanada.jpg?itok=iF7oswQt',
    'https://comohacerpanqueques.info/wp-content/uploads/2018/06/receta-de-empanadas-de-pollo-1024x683.jpg',
    'https://comidastipicaschilenas.cl/wp-content/uploads/2020/10/Receta-de-chaparritas-chilenas.jpg',
    'https://odoo.sf.cloudccu.cl/web/image?model=product.product&id=2300&field=image_1024',
    'https://www.cocacola.es/content/dam/one/es/es2/coca-cola/products/productos/dic-2021/CC_Origal.jpg',
    'https://cdnx.jumpseller.com/dc-central-distribuidora-de-licores/image/11707248/139.jpg?1648116031',
    'https://cdn.shopify.com/s/files/1/0287/1256/6887/products/Bilz2.jpg?v=1613624983',
  ];

  late int _expandedIndex;
  late List<bool> _isCheckedList;
  late List<int> _itemQuantities;

  @override
  void initState() {
    super.initState();
    _expandedIndex = -1;
    _isCheckedList = List.generate(_titles.length, (index) => false);
    _itemQuantities = List.generate(_titles.length, (index) => 0);
  }

  void _toggleExpanded(int index) {
    setState(() {
      if (_expandedIndex == index) {
        _expandedIndex = -1;
      } else {
        _expandedIndex = index;
      }
    });
  }

  double _calculateTotalValue() {
    double totalValue = 0;
    for (int i = 0; i < _isCheckedList.length; i++) {
      if (_isCheckedList[i]) {
        totalValue += _prices[i] * (_itemQuantities[i] > 0 ? _itemQuantities[i] : 1);
      }
    }
    return totalValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Happines & Food alpha'),
      ),
      body: ListView.builder(
        itemCount: _titles.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: InkWell(
              onTap: () {
                _toggleExpanded(index);
              },
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      _titles[index],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Icon(
                      _expandedIndex == index
                          ? Icons.expand_less
                          : Icons.expand_more,
                    ),
                  ),
                  if (_expandedIndex == index)
                    Column(
                      children: [
                        Image.network(
                          _imageUrls[index],
                          fit: BoxFit.contain,
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '\$${_prices[index]}',
                                style: TextStyle(fontSize: 16),
                              ),
                              Checkbox(
                                value: _isCheckedList[index],
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isCheckedList[index] = value ?? false;
                                    if (!value!) {
                                      _itemQuantities[index] = 0;
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Counter(
                          count: _isCheckedList[index] ? 1 : 0,
                          onChanged: (int count) {
                            setState(() {
                              _itemQuantities[index] = count;
                            });
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Precio total: \$${_calculateTotalValue().toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Lógica de compra
                },
                child: Text('Comprar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Counter extends StatelessWidget {
  final int count;
  final ValueChanged<int> onChanged;

  const Counter({
    Key? key,
    required this.count,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            onChanged(count - 1);
          },
          icon: Icon(Icons.remove),
        ),
        Text(count.toString()),
        IconButton(
          onPressed: () {
            onChanged(count + 1);
          },
          icon: Icon(Icons.add),
        ),
      ],
    );
  }
}


