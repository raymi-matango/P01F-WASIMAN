import 'package:flutter/material.dart';

class Conductor extends StatelessWidget {
  final String nombre;
  final String telefono;
  final String correo;

  Conductor(
      {required this.nombre, required this.telefono, required this.correo});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Nombre: $nombre',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Teléfono: $telefono',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Correo: $correo',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
