import 'package:flutter/material.dart';
import 'package:haf/counter.dart';

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
        primarySwatch: Colors.blue,
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

  late List<bool> _isCheckedList;

  @override
  void initState() {
    super.initState();
    _isCheckedList = List.generate(_titles.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Happines & Food alpha'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        children: List.generate(_titles.length, (index) {
          return Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Image.network(
                    _imageUrls[index],
                    //width: 200,
                    //height: 100,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  _titles[index],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${_prices[index]}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Checkbox(
                      value: _isCheckedList[index],
                      onChanged: (value) {
                        setState(() {
                          _isCheckedList[index] = value!;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Counter(),
              ],
            ),
          );
        }),
      ),
    );
  }
}
