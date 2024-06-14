import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class DetalleComentarios extends StatefulWidget {
  const DetalleComentarios({Key? key});

  @override
  State<DetalleComentarios> createState() => _DetalleComentariosState();
}

class _DetalleComentariosState extends State<DetalleComentarios> {
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

  Future<void> _eliminarComentario(int comentarioId) async {
    final response = await http.delete(
      Uri.parse(
          'http://192.168.137.1:7777/api/comentarios/eliminar/$comentarioId'),
      headers: <String, String>{
        'Authorization': 'Bearer $_token',
      },
    );
    if (response.statusCode == 200) {
      // Si la eliminación fue exitosa, actualiza la lista de comentarios
      setState(() {
        // Aquí deberías actualizar la lista de comentarios, ya sea volviendo a llamar fetchComentarios o eliminando el comentario de la lista actual.
      });
    } else {
      // Si la eliminación no fue exitosa, muestra un mensaje de error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('No se pudo eliminar el comentario.'),
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

  Future<List<dynamic>> fetchComentarios() async {
    final response = await http.get(
      Uri.parse('http://192.168.137.1:7777/api/comentarios/ver'),
      headers: <String, String>{
        'Authorization': 'Bearer $_token',
      },
    );
    if (response.statusCode == 200) {
      // Si la solicitud fue exitosa, analiza el JSON
      Map<String, dynamic> data = jsonDecode(response.body);
      return data['comentarios'];
    } else {
      // Si la solicitud no fue exitosa, lanza una excepción
      throw Exception('Failed to load comentarios');
    }
  }

  Future<void> _mostrarConfirmacionEliminar(
      BuildContext context, int comentarioId) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmación'),
        content: Text('¿Está seguro de eliminar este comentario?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              _eliminarComentario(comentarioId);
            },
            child: Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MIS COMENTARIOS',
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
        future: fetchComentarios(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Mientras espera, muestra un indicador de progreso
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Si hay un error, muestra un mensaje de error
            return Center(
              child: Text(
                'Error al cargar comentarios',
                style: TextStyle(color: Colors.red), // Color del texto de error
              ),
            );
          } else {
            // Si la llamada a la API fue exitosa, muestra los comentarios
            List<dynamic> comentarios = snapshot.data!;
            return AnimationLimiter(
              child: ListView.builder(
                itemCount: comentarios.length,
                itemBuilder: (context, index) {
                  final comentario = comentarios[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 300),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Card(
                          child: InkWell(
                            onTap: () {
                              _mostrarConfirmacionEliminar(
                                  context, comentario['id']);
                            },
                            child: ListTile(
                              title: Text(
                                comentario['comentario'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFF0E402E), // Color del título
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Calificación: ${comentario['calificacion']}',
                                    style: TextStyle(
                                      color:
                                          Color(0xFFBF8756), // Color del texto
                                    ),
                                  ),
                                  Text(
                                    'Fecha: ${comentario['fecha'].toString().split('T')[0]}',
                                    style: TextStyle(
                                      color:
                                          Color(0xFFBF8756), // Color del texto
                                    ),
                                  ),
                                  Text(
                                    'Nombre del viaje: ${comentario['viaje']['nombre']}',
                                    style: TextStyle(
                                      color:
                                          Color(0xFFBF8756), // Color del texto
                                    ),
                                  ),
                                  Text(
                                    'Destino: ${comentario['viaje']['destino']}',
                                    style: TextStyle(
                                      color:
                                          Color(0xFFBF8756), // Color del texto
                                    ),
                                  ),
                                  Text(
                                    'Fecha del viaje: ${comentario['viaje']['fecha']}',
                                    style: TextStyle(
                                      color:
                                          Color(0xFFBF8756), // Color del texto
                                    ),
                                  ),
                                  Text(
                                    'Hora del viaje: ${comentario['viaje']['hora']}',
                                    style: TextStyle(
                                      color:
                                          Color(0xFFBF8756), // Color del texto
                                    ),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 25,
                                ),
                                onPressed: () {
                                  _mostrarConfirmacionEliminar(
                                      context, comentario['id']);
                                },
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
