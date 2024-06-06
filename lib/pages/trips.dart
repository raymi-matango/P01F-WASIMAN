import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ViajePagina extends StatefulWidget {
  const ViajePagina({Key? key}) : super(key: key);

  @override
  State<ViajePagina> createState() => _ViajePaginaState();
}

class _ViajePaginaState extends State<ViajePagina> {
  List<dynamic> viajes = [];

  @override
  void initState() {
    super.initState();
    _fetchViajes();
  }

  Future<void> _fetchViajes() async {
    final token = await TokenManager.getToken();

    if (token == null) {
      // Manejar el caso en que el token no esté disponible
      print('Token no disponible');
      return;
    }

    final response = await http.get(
      Uri.parse('http://localhost:7777/api/viajes/listar'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      setState(() {
        viajes = json.decode(response.body);
      });
    } else {
      // Manejar el error de manera apropiada
      print('Error al cargar los viajes: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Viajes'),
      ),
      body: viajes.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: viajes.length,
              itemBuilder: (context, index) {
                final viaje = viajes[index];
                return ListTile(
                  title: Text(viaje['destino'] ?? ''),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fecha de Salida: ${viaje['fechaSalida'] ?? ''}'),
                      Text('Hora de Salida: ${viaje['horaSalida'] ?? ''}'),
                      Text(
                          'Puntos de Recogida: ${viaje['puntosRecogida'] ?? ''}'),
                      Text(
                          'Capacidad de Asientos: ${viaje['capacidadAsientos'] ?? ''}'),
                      Text('Detalles: ${viaje['detalles'] ?? ''}'),
                      Text('Disponible: ${viaje['disponible'] ?? ''}'),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class TokenManager {
  static const _key = 'jwt_token';

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }
}
