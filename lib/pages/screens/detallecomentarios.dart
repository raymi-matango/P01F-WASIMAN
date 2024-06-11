import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<List<dynamic>> fetchComentarios() async {
    final response = await http.get(
      Uri.parse('http://localhost:7777/api/comentarios/ver'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comentarios'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchComentarios(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Mientras espera, muestra un indicador de progreso
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Si hay un error, muestra un mensaje de error
            return Center(child: Text('Error al cargar comentarios'));
          } else {
            // Si la llamada a la API fue exitosa, muestra los comentarios
            List<dynamic> comentarios = snapshot.data!;
            return ListView.builder(
              itemCount: comentarios.length,
              itemBuilder: (context, index) {
                final comentario = comentarios[index];
                return ListTile(
                  title: Text(comentario['comentario']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Calificación: ${comentario['calificacion']}'),
                      Text('Fecha: ${comentario['fecha']}'),
                      Text(
                          'Nombre del viaje: ${comentario['viaje']['nombre']}'),
                      Text('Destino: ${comentario['viaje']['destino']}'),
                      Text('Fecha del viaje: ${comentario['viaje']['fecha']}'),
                      Text('Hora del viaje: ${comentario['viaje']['hora']}'),
                    ],
                  ),
                  // Puedes agregar más campos aquí según la estructura de tus datos
                );
              },
            );
          }
        },
      ),
    );
  }
}
