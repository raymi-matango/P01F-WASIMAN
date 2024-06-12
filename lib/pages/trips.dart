import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iniciofront/pages/screens/comentarios.dart';
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
        Uri.http('192.168.137.1:7777', '/api/viajes/buscar', queryParameters);

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

  Future<void> _seleccionarHora(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      String hora = picked.format(context); // Obtener la hora seleccionada
      // Eliminar el AM/PM del formato de la hora
      hora = hora.replaceAll(
          RegExp(r'\s?[AP]M'), ''); // Elimina el AM o PM, si existe
      setState(() {
        _horaController.text = hora;
      });
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

  void _detallesViaje(int viajeId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConductorDetalle(
            viaje: destinos.firstWhere((element) => element['id'] == viajeId)),
      ),
    );
  }

  void _mostrarFiltro() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Búsqueda Avanzada'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nombreController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      // Limpia el texto cuando se presiona el icono
                      _nombreController.clear();
                      _buscarViajes();
                    },
                  ),
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
                onTap: () {
                  _seleccionarHora(context);
                },
                readOnly: true,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      // Limpia el texto cuando se presiona el icono
                      _horaController.clear();
                      _buscarViajes();
                    },
                  ),
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
        title: const Text(
          'Destinos para tu viaje',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xff688C6A),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xff688C6A)
              .withOpacity(0.5), // Color de fondo del contenedor
        ),
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: TextStyle(color: Color(0xFF0E402E)),
                        controller: _destinoController,
                        onChanged: (text) {
                          _buscarViajes();
                        },
                        decoration: InputDecoration(
                          labelText: 'Escriba el destino deseado',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors
                                  .orange, // Color del borde cuando no está enfocado
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors
                                  .orange, // Color del borde cuando está enfocado
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              FontAwesomeIcons.solidCircleXmark,
                              color: Color(0xFF0E402E).withOpacity(0.7),
                            ),
                            onPressed: () {
                              // Limpia el texto cuando se presiona el icono
                              _destinoController.clear();
                              _buscarViajes();
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                        width: 8), // Espacio entre el TextField y el IconButton
                    IconButton(
                      icon: Icon(
                        FontAwesomeIcons.filter,
                        color: Color(0xFF0E402E).withOpacity(0.7),
                        size: 25,
                      ),
                      onPressed: _mostrarFiltro,
                    ),
                  ],
                ),
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
                          stars:
                              destinos[firstIndex]['calificacion'].toString(),
                          userName: destinos[firstIndex]['nombre'],
                          hora: destinos[firstIndex]['hora'],
                          location: destinos[firstIndex]['destino'],
                          available: destinos[firstIndex]['disponible'],
                          onTap: () =>
                              _detallesViaje(destinos[firstIndex]['id']),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: _buildCatCardItem(
                          hora: destinos.length > secondIndex
                              ? destinos[secondIndex]['hora']
                              : '',
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
                                  _detallesViaje(destinos[secondIndex]['id'])
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
      ),
    );
  }

  Widget _buildCatCardItem({
    required String imageUrl,
    required String stars,
    required String userName,
    required String hora,
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
                        color: Colors.orange,
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
                        color: Color(0xffBF8756),
                      ),
                      const SizedBox(width: 0.5),
                      Text(
                        userName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        FontAwesomeIcons.clock,
                        color: Colors.white,
                        size: 11,
                      ),
                      Text(
                        hora,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11),
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
                  color: Color(0xFF0E402E),
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

////Viajes Detallles//////////////////////////////////////
///

class ConductorDetalle extends StatelessWidget {
  final Map<String, dynamic> viaje;

  ConductorDetalle({Key? key, required this.viaje}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> comentarios =
        List<Map<String, dynamic>>.from(viaje['comentarios']);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffBF8756),
        centerTitle: true,
        title: const Text(
          '¡Explora y Reserva!',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
            color: Colors.white), // Cambia el color del icono de regreso
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xff688C6A)
              .withOpacity(0.2), // Color de fondo del contenedor
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: viaje['foto'] != null
                          ? Image.network(
                              viaje['foto'],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            )
                          : Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDataRow('Destino:', viaje['destino']),
                      _buildDataRow('Origen:', viaje['origen']),
                      _buildDataRow('Hora:', viaje['hora']),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          _buildStarRating(viaje['calificacion']),
                          SizedBox(width: 10),
                          ElevatedButton.icon(
                            onPressed: () {
                              // Acción al presionar el botón de calificar
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ComentarioPagina(viajeId: viaje['id']),
                                ),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Color(0xff0E402E)
                                      .withOpacity(0.8)), // Color del botón
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      vertical: 16.0,
                                      horizontal:
                                          20.0)), // Ajuste del espaciado interno
                            ),
                            icon: Icon(
                              FontAwesomeIcons
                                  .solidPenToSquare, // Ícono de lápiz
                              size: 20, // Tamaño del ícono
                            ),
                            label: Text(
                              'Calificar', // Texto del botón
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white), // Tamaño del texto
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text('Datos del Conductor:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              _buildDataRow('Nombre:', viaje['nombre']),
              _buildDataRow('Correo:', viaje['correo']),
              _buildDataRow('Facultad:', viaje['facultad']),
              _buildDataRow('Teléfono:', viaje['telefono']),
              SizedBox(height: 20),
              Text('Comentarios:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: comentarios.length,
                  itemBuilder: (context, index) {
                    return _buildComentarioItem(comentarios[index]);
                  },
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ReservaPagina(viajeId: viaje['id']),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text('Reservar', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataRow(String title, String value) {
    return Row(
      children: [
        Text(title, style: TextStyle(fontSize: 16)),
        SizedBox(width: 20),
        Text(value, style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildStarRating(double rating) {
    return Row(
      children: [
        Icon(FontAwesomeIcons.solidStar, color: Colors.orange),
        SizedBox(width: 5),
        Text(rating.toString(), style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildComentarioItem(Map<String, dynamic> comentario) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Usuario: ${comentario['usuario']}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Text('Comentario: ${comentario['comentario']}',
              style: TextStyle(fontSize: 16)),
          SizedBox(height: 5),
          Row(
            children: [
              Text('Calificación: ', style: TextStyle(fontSize: 16)),
              _buildStarRating(comentario['calificacion']),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Icon(Icons.thumb_up),
              SizedBox(width: 5),
              Icon(Icons.thumb_down),
              SizedBox(width: 5),
              Text('Reportar'),
            ],
          ),
        ],
      ),
    );
  }
}
