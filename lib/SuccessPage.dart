import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SuccessPage extends StatelessWidget {
  final String message;
  final String gifUrl;

  SuccessPage({required this.message, required this.gifUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Éxito'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            CachedNetworkImage(
              imageUrl: gifUrl,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ],
        ),
      ),
    );
  }
}
