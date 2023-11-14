import 'package:flutter/material.dart';

class Constants {
  
  static void snackbar(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(label),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        elevation: 5.0,
      )
    );
  }

  static void showDialogMessage(BuildContext context, String label){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alerta'),
          content: Text(label),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}