import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PurchasesHistoryPage extends StatefulWidget {
  @override
  _PurchasesHistoryPageState createState() => _PurchasesHistoryPageState();
}

class _PurchasesHistoryPageState extends State<PurchasesHistoryPage> {
  List<Map<String, dynamic>> purchases = [];

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
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/purchases?user_id=$userId'));

    if (response.statusCode == 200) {
      final dynamic jsonResponse = json.decode(response.body);

      if (jsonResponse is List) {
        setState(() {
          purchases = jsonResponse.map((purchase) => {
            'id': purchase['id'].toString(),
            'amount': purchase['amount'].toString(),
            'date': purchase['date'].toString(),
          }).toList();
        });
      } else {
        print('Invalid response format: $jsonResponse');
      }
    } else {
      print('Error en la solicitud GET: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Future<void> showNotification(String purchaseId, String amount, String date) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('channel_id', 'channel_name', channelDescription:"Your description",
            importance: Importance.max, priority: Priority.high, ticker: 'ticker');
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

          return ListTile(
            title: Text('Compra $purchaseId'),
            subtitle: Text('Monto: $amount - Fecha: $date'),
            trailing: ElevatedButton(
              child: Text('Notificar'),
              onPressed: () {
                if (purchaseId != null && amount != null && date != null) {
                  showNotification(purchaseId, amount, date);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
