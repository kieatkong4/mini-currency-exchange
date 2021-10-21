import 'package:flutter/material.dart';

Future<Null> aDialog(
    BuildContext context, String title, String message) async {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: ListTile(
        title: Text(title),
        subtitle: Text(message),
      ),children: [TextButton(onPressed: ()=>Navigator.pop(context), child: Text("OK"))],
    ),
  );
}
