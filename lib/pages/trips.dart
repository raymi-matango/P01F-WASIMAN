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
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _destinoController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _horaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchViajes();
  }

  Future<void> _fetchViajes(
      {String? nombre, String? destino, String? fecha, String? hora}) async {
    final token = await TokenManager.getToken();
    final queryParameters = {
      'nombre': nombre,
      'destino': destino,
      'fecha': fecha,
      'hora': hora,
    }..removeWhere((key, value) => value == null || value.isEmpty);

    final uri =
        Uri.http('localhost:7777', '/api/viajes/buscar', queryParameters);

    final response = await http.get(
      uri,
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

  void _buscarViajes() {
    _fetchViajes(
      nombre: _nombreController.text,
      destino: _destinoController.text,
      fecha: _fechaController.text,
      hora: _horaController.text,
    );
  }

  void _reservarAsientos(int viajeId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReservaPagina(viajeId: viajeId),
      ),
    );
  }

//mensaje:
  void _mostrarFiltro() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Búsqueda'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0), // Espacio entre los TextFields
              TextField(
                controller: _horaController,
                decoration: InputDecoration(
                  labelText: 'Hora',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                _buscarViajes();
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Buscar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Destinos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _destinoController,
                    onChanged: (text) {
                      // Realiza la búsqueda cada vez que el texto cambie
                      _buscarViajes();
                    },
                    decoration: InputDecoration(
                      labelText: 'Destino',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          // Limpia el texto cuando se presiona el icono
                          _destinoController.clear();
                          _buscarViajes();
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                    width: 8), // Espacio entre el TextField y el IconButton
                IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.filter,
                    color: Color(0xFFF2B90C),
                    size: 24,
                  ),
                  onPressed: _mostrarFiltro,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
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
                        onTap: () =>
                            _reservarAsientos(destinos[firstIndex]['id']),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: _buildCatCardItem(
                        imageUrl: destinos.length > secondIndex
                            ? destinos[secondIndex]['foto']
                            : '',
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
                            ? () =>
                                _reservarAsientos(destinos[secondIndex]['id'])
                            : () {},
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
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
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.userTie,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        userName,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
