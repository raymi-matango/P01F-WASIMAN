import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
        title: const Text(
          'NOTIFICACIÓN',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        backgroundColor: Color(0xff0E402E),
        centerTitle: true,
        iconTheme: IconThemeData(
            color: Colors
                .white), // Cambia el color del icono de la barra de aplicación
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
              ElevatedButton(
                onPressed: () async {
                  String phoneNumber =
                      '+593998064828'; // Reemplaza con el número de teléfono del destinatario, sin el símbolo "+"
                  String message =
                      'Hola, estoy en el punto de encuentro, ¿dónde estás?'; // Reemplaza con el mensaje que deseas enviar
                  String url =
                      'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}';

                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'No se pudo abrir el enlace $url';
                  }
                },
                child: Text('Enviar mensaje en WhatsApp'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
