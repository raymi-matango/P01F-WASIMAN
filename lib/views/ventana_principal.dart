import 'package:flutter/material.dart';

class VentanaPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ventana Principal'),
      ),
      body: Center(
        child: Text('Bienvenido a la Ventana Principal!'),
      ),
    );
  }
}
