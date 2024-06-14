import 'package:flutter/material.dart';

class Notificacion extends StatefulWidget {
  final String fechaIngreso;

  Notificacion({required this.fechaIngreso});

  @override
  _NotificacionState createState() => _NotificacionState();
}

class _NotificacionState extends State<Notificacion> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      margin: EdgeInsets.all(16.0),
      color: Color(0xFFF2CA50),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¡Bienvenido a la aplicación!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0E402E),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Ingresaste el ${widget.fechaIngreso} para iniciar con la reserva.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF688C6A),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // Agregar aquí la funcionalidad del botón si es necesario
                  },
                  child: Text(
                    'Cerrar',
                    style: TextStyle(
                      color: Color(0xFFBF8756),
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
