import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iniciofront/pages/screens/reservas.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TokenManager {
  static const _key = 'jwt_token';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }

  static Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

class ViajePagina extends StatefulWidget {
  const ViajePagina({Key? key}) : super(key: key);

  @override
  State<ViajePagina> createState() => _ViajePaginaState();
}

class _ViajePaginaState extends State<ViajePagina> {
  List<dynamic> destinos = [];

  @override
  void initState() {
    super.initState();
    _fetchViajes();
  }

  Future<void> _fetchViajes() async {
    final token = await TokenManager.getToken();

    final response = await http.get(
      Uri.parse('http://localhost:7777/api/viajes/listar'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final List<dynamic> viajes = responseData['viajes'];
      setState(() {
        destinos = viajes;
      });
    } else {
      print('Error al cargar los viajes: ${response.statusCode}');
    }
  }

  void _reservarAsientos(int viajeId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReservaPagina(viajeId: viajeId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Destinos'),
      ),
      body: ListView.builder(
        itemCount: (destinos.length / 2).ceil(),
        itemBuilder: (context, index) {
          final int firstIndex = index * 2;
          final int secondIndex = index * 2 + 1;
          return Row(
            children: [
              Expanded(
                child: _buildCatCardItem(
                  imageUrl: destinos[firstIndex]['foto'],
                  stars: destinos[firstIndex]['calificacion'].toString(),
                  userName: destinos[firstIndex]['nombre'],
                  location: destinos[firstIndex]['destino'],
                  available: destinos[firstIndex]['disponible'],
                  onTap: () => _reservarAsientos(destinos[firstIndex]['id']),
                ),
              ),
              SizedBox(width: 8), // Espaciado entre las tarjetas
              Expanded(
                child: _buildCatCardItem(
                  imageUrl: destinos.length > secondIndex
                      ? destinos[secondIndex]['foto']
                      : '', // Evita errores si no hay suficientes destinos
                  stars: destinos.length > secondIndex
                      ? destinos[secondIndex]['calificacion'].toString()
                      : '',
                  userName: destinos.length > secondIndex
                      ? destinos[secondIndex]['nombre']
                      : '',
                  location: destinos.length > secondIndex
                      ? destinos[secondIndex]['destino']
                      : '',
                  available: destinos.length > secondIndex
                      ? destinos[secondIndex]['disponible']
                      : false,
                  onTap: destinos.length > secondIndex
                      ? () => _reservarAsientos(destinos[secondIndex]['id'])
                      : () {},
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCatCardItem({
    required String imageUrl,
    required String stars,
    required String userName,
    required String location,
    required bool available,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Image.network(
                  imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.solidStar,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        stars,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                if (available)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.green,
                        radius: 8,
                      ),
                    ),
                  ),
              ],
            ),
            ListTile(
              title: Text(
                location,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
