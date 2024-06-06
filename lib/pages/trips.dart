import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Viaje {
  final int id;
  final String destino;
  final String fechaSalida;
  final String horaSalida;
  final String puntosRecogida;
  final int capacidadAsientos;
  final String detalles;
  final bool disponible;

  Viaje({
    required this.id,
    required this.destino,
    required this.fechaSalida,
    required this.horaSalida,
    required this.puntosRecogida,
    required this.capacidadAsientos,
    required this.detalles,
    required this.disponible,
  });

  factory Viaje.fromJson(Map<String, dynamic> json) {
    return Viaje(
      id: json['id'],
      destino: json['destino'],
      fechaSalida: json['fechaSalida'],
      horaSalida: json['horaSalida'],
      puntosRecogida: json['puntosRecogida'],
      capacidadAsientos: json['capacidadAsientos'],
      detalles: json['detalles'],
      disponible: json['disponible'],
    );
  }
}

class ViajePagina extends StatefulWidget {
  @override
  _ViajePaginaState createState() => _ViajePaginaState();
}

class _ViajePaginaState extends State<ViajePagina> {
  late Future<List<Viaje>> futureViajes;

  @override
  void initState() {
    super.initState();
    futureViajes = _fetchViajes();
  }

  Future<List<Viaje>> _fetchViajes() async {
    final response =
        await http.get(Uri.parse('http://localhost:7777/api/viajes/listar'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body)['viajes'] as List;
      return jsonResponse.map((viaje) => Viaje.fromJson(viaje)).toList();
    } else {
      throw Exception('Failed to load viajes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Viajes'),
      ),
      body: FutureBuilder<List<Viaje>>(
        future: futureViajes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Viaje> viajes = snapshot.data!;
            return ListView.builder(
              itemCount: viajes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(viajes[index].destino),
                  subtitle: Text(
                      'Fecha de salida: ${viajes[index].fechaSalida}, Hora de salida: ${viajes[index].horaSalida}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
