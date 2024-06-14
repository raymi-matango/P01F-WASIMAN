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
    return Scaffold(
      appBar: AppBar(
        title: Text('Notificación'),
      ),
      body: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        margin: EdgeInsets.all(16.0),
        color: Color(0xffF1F2F0),
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
                  color: Color(0xffF29F05),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cerrar',
                      style: TextStyle(
                        color: Color.fromARGB(255, 242, 68, 5),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
