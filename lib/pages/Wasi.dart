import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
      ),
      body: Center(
        child: Text(
          '¡Bienvenido a tu página de inicio!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
