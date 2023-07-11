import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PurchasesHistoryAdminPage extends StatefulWidget {
  @override
  _PurchasesHistoryAdminPageState createState() =>
      _PurchasesHistoryAdminPageState();
}

class _PurchasesHistoryAdminPageState extends State<PurchasesHistoryAdminPage> {
  List<Map<String, dynamic>> purchases = [
    {
      'id': '001',
      'amount': '25000',
      'date': '2023-07-01',
      'contact': '+56912345678',
    },
    {
      'id': '002',
      'amount': '15000',
      'date': '2023-07-02',
      'contact': '+56987654321',
    },
    {
      'id': '003',
      'amount': '30000',
      'date': '2023-07-03',
      'contact': '+56955555555',
    },
  ];

  @override
  void initState() {
    super.initState();
    loadPurchases();
  }

  Future<void> loadPurchases() async {
    // Obtiene el ID de usuario del almacenamiento local
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId') ?? '';

    // Realiza la solicitud al API para obtener las compras del usuario
    final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/purchases?user_id=$userId'));

    if (response.statusCode == 200) {
      final dynamic jsonResponse = json.decode(response.body);

      if (jsonResponse is List) {
        setState(() {
          purchases.addAll(jsonResponse
              .map((purchase) => {
                    'id': purchase['id'].toString(),
                    'amount': purchase['amount'].toString(),
                    'date': purchase['date'].toString(),
                    'contact': purchase['contact'].toString(),
                  })
              .toList());
        });
      } else {
        print('Invalid response format: $jsonResponse');
      }
    } else {
      print('Error en la solicitud GET: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Future<void> showNotification(
      String purchaseId, String amount, String date) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'channel_id', 'channel_name', channelDescription: 'Your description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await FlutterLocalNotificationsPlugin().show(
      0,
      'Compra Lista',
      'La compra $purchaseId está lista para retiro.\nMonto: $amount\nFecha: $date',
      platformChannelSpecifics,
      payload: 'item id 2',
    );
  }

  Future<void> confirmNotification(
      String purchaseId, String amount, String date) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmación'),
          content: Text(
              '¿Estás seguro de que quieres notificar al usuario del retiro?'),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Notificar'),
              onPressed: () {
                showNotification(purchaseId, amount, date);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Últimas Compras'),
      ),
      body: ListView.builder(
        itemCount: purchases.length,
        itemBuilder: (context, index) {
          final purchase = purchases[index];
          final purchaseId = purchase['id'];
          final amount = purchase['amount'];
          final date = purchase['date'];
          final contact = purchase['contact'];

          return ListTile(
            title: Text('Compra $purchaseId'),
            subtitle: Text('Monto: \$${amount} CLP - Fecha: $date'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  child: Text('Notificar'),
                  onPressed: () {
                    if (contact != null) {
                      confirmNotification(purchaseId, amount, date);
                    }
                  },
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  child: Text('Contactar'),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Contacto'),
                          content: Text('Número de contacto: $contact'),
                          actions: [
                            TextButton(
                              child: Text('Cerrar'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
