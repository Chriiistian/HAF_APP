import 'package:flutter/material.dart';

class Purchase {
  final String id;
  final double amount;
  final DateTime date;

  Purchase({required this.id, required this.amount, required this.date});
}

class PurchasesPage extends StatelessWidget {
  final List<Purchase> purchases = [
    Purchase(
      id: '0001',
      amount: 19990,
      date: DateTime(2023, 6, 1),
    ),
    Purchase(
      id: '0002',
      amount: 9990,
      date: DateTime(2023, 5, 28),
    ),
    Purchase(
      id: '0003',
      amount: 14990,
      date: DateTime(2023, 5, 25),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Últimas compras'),
      ),
      body: ListView.builder(
        itemCount: purchases.length,
        itemBuilder: (context, index) {
          final purchase = purchases[index];
          return ListTile(
            title: Text('ID: ${purchase.id}'),
            subtitle: Text('Monto: ${purchase.amount.toStringAsFixed(0)} CLP'),
            trailing: Text('Fecha: ${purchase.date.day}/${purchase.date.month}/${purchase.date.year}'),
          );
        },
      ),
    );
  }
}
