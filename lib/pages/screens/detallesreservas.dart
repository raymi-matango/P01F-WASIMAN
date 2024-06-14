import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:url_launcher/url_launcher.dart';

class DetalleReservas extends StatefulWidget {
  const DetalleReservas({Key? key});

  @override
  State<DetalleReservas> createState() => _DetalleReservasState();
}

class _DetalleReservasState extends State<DetalleReservas> {
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('jwt_token');
    });
  }

  Future<void> _cancelarReserva(int reservaId) async {
    final response = await http.delete(
      Uri.parse('http://192.168.137.1:7777/api/reservas/cancelar/$reservaId'),
      headers: <String, String>{
        'Authorization': 'Bearer $_token',
      },
    );
    if (response.statusCode == 200) {
      // Si la cancelación fue exitosa, actualiza la lista de reservas
      setState(() {
        // Aquí deberías actualizar la lista de reservas, ya sea volviendo a llamar fetchReservas o eliminando la reserva de la lista actual.
      });
    } else {
      // Si la cancelación no fue exitosa, muestra un mensaje de error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('No se pudo cancelar la reserva.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<List<dynamic>> fetchReservas() async {
    final response = await http.get(
      Uri.parse('http://192.168.137.1:7777/api/reservas/detalles'),
      headers: <String, String>{
        'Authorization': 'Bearer $_token',
      },
    );
    if (response.statusCode == 200) {
      // Si la solicitud fue exitosa, analiza el JSON
      Map<String, dynamic> data = jsonDecode(response.body);
      return data['reservas'];
    } else {
      // Si la solicitud no fue exitosa, lanza una excepción
      throw Exception('Failed to load reservas');
    }
  }

  Future<void> _mostrarConfirmacionCancelar(
      BuildContext context, int reservaId) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmación'),
        content: Text('¿Está seguro de cancelar esta reserva?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('NO'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              _cancelarReserva(reservaId);
            },
            child: Text('SI'),
          ),
        ],
      ),
    );
  }

  void _launchWhatsapp(
      {required String number, required String message}) async {
    final String url =
        "whatsapp://send?phone=$number&text=${Uri.encodeFull(message)}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Can't open WhatsApp");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MIS RESERVAS',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xff688C6A),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 30,
        ), // Cambia el color del icono de la barra de aplicación
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchReservas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Mientras espera, muestra un indicador de progreso
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Si hay un error, muestra un mensaje de error
            return Center(
              child: Text(
                'Error al cargar reservas',
                style: TextStyle(color: Colors.red), // Color del texto de error
              ),
            );
          } else {
            // Si la llamada a la API fue exitosa, muestra los detalles de las reservas
            List<dynamic> reservas = snapshot.data!;
            return AnimationLimiter(
              child: ListView.builder(
                itemCount: reservas.length,
                itemBuilder: (context, index) {
                  final reserva = reservas[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 300),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Card(
                          child: InkWell(
                            onTap: () {
                              _mostrarConfirmacionCancelar(
                                  context, reserva['id']);
                            },
                            child: ListTile(
                              title: Text(
                                '${reserva['viaje']['destino']}',
                                style: TextStyle(
                                    color:
                                        Color(0xFF0E402E), // Color del título
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Fecha: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFBF8756),
                                            fontSize: 15,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              '${reserva['fecha'].toString().split('T')[0]}',
                                          style: TextStyle(
                                            color: Color(0xFFBF8756),
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Estado: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFF29F05),
                                            fontSize: 15,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '${reserva['estado']}',
                                          style: TextStyle(
                                            color: Color(0xFFF29F05),
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Asiento: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF0E402E),
                                            fontSize: 15,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '${reserva['asiento']}',
                                          style: TextStyle(
                                            color: Color(0xFF0E402E),
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Ubicación: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFBF8756),
                                            fontSize: 15,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '${reserva['ubicacion']}',
                                          style: TextStyle(
                                            color: Color(0xFFBF8756),
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    child: Material(
                                      color: Colors.transparent,
                                      child: ClipOval(
                                        child: InkWell(
                                          onTap: () {
                                            _mostrarConfirmacionCancelar(
                                                context, reserva['id']);
                                          },
                                          splashColor:
                                              Color.fromARGB(62, 255, 157, 0),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      width: 16), // Espacio entre los íconos
                                  GestureDetector(
                                    onTap: () {
                                      // Acción para el ícono de WhatsApp
                                    },
                                    child: Material(
                                      color: Colors.transparent,
                                      child: ClipOval(
                                        child: InkWell(
                                          onTap: () {
                                            _launchWhatsapp(
                                                number: "+593993994147",
                                                message:
                                                    "Hola, estoy en el punto de encuentro. ¿Dónde estás tú?");
                                          },
                                          splashColor:
                                              Color.fromARGB(62, 255, 157, 0),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.telegram,
                                              color: Colors.green,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
