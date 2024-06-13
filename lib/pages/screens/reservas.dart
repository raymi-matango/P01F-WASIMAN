import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

class ReservaPagina extends StatefulWidget {
  final int viajeId;

  ReservaPagina({required this.viajeId});

  @override
  _ReservaPaginaState createState() => _ReservaPaginaState();
}

class _ReservaPaginaState extends State<ReservaPagina> {
  final _cantidadAsientosController = TextEditingController();
  final _ubicacionController =
      TextEditingController(); // Controlador para la ubicación
  bool _isLoading = false;

  Future<void> _mostrarDialogo(String mensaje) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 60),
              SizedBox(height: 16),
              Text(mensaje),
            ],
          ),
        );
      },
    );

    await Future.delayed(Duration(seconds: 2));
    Navigator.of(context).pop();
  }

  Future<void> _reservarAsientos() async {
    final cantidadAsientos = int.tryParse(_cantidadAsientosController.text);
    if (cantidadAsientos == null || cantidadAsientos <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ingrese una cantidad válida de asientos')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final token = await TokenManager.getToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Token no disponible. Por favor, inicie sesión de nuevo.')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final uri = Uri.parse('http://192.168.137.1:7777/api/reservas/crear');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'viajeId': widget.viajeId,
        'cantidadAsientos': cantidadAsientos,
        'ubicacion': _ubicacionController
            .text, // Usamos el valor ingresado en el campo de texto de ubicación
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      await _mostrarDialogo(responseData['message']);
      Navigator.pop(context);
    } else {
      final responseData = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Error al realizar la reserva: ${responseData['error'] ?? response.body}')),
      );
    }
  }

  @override
  void dispose() {
    _cantidadAsientosController.dispose();
    _ubicacionController.dispose(); // Liberar el controlador de la ubicación
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservar Asientos'),
        backgroundColor: Color(0xFF0E402E),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            TextField(
              controller: _cantidadAsientosController,
              decoration: InputDecoration(
                labelText: 'Cantidad de Asientos',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _ubicacionController,
              decoration: InputDecoration(
                labelText: 'Ubicación',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _reservarAsientos,
                    child: Text('CONFIRMAR'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Color(0xffBF8756), // Color de fondo del botón
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
