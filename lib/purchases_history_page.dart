import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PurchasesHistoryPage extends StatelessWidget {
  final List<Map<String, String>> purchases = [
    {
      'id': '001',
      'amount': '10,000 CLP',
      'date': '10/06/2023',
    },
    {
      'id': '002',
      'amount': '15,000 CLP',
      'date': '12/06/2023',
    },
    {
      'id': '003',
      'amount': '20,000 CLP',
      'date': '15/06/2023',
    },
  ];

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