import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ventana_principal.dart'; // Asegúrate de importar correctamente la clase VentanaPrincipal

class LoginVentana extends StatefulWidget {
  @override
  _LoginVentanaState createState() => _LoginVentanaState();
}

class _LoginVentanaState extends State<LoginVentana> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _claveController = TextEditingController();

  Future<void> _login() async {
    final String email = _emailController.text;
    final String clave = _claveController.text;

    final Map<String, String> datosLogin = {
      'email': email,
      'clave': clave,
    };

    try {
      final response = await http.post(
        Uri.parse('http://192.168.137.1:7777/api/autenticar/login'),
        body: json.encode(datosLogin),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('Mensaje de la API: ${data['mensaje']}');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => VentanaPrincipal()),
        );
      } else {
        print('Error al iniciar sesión: ${response.reasonPhrase}');
        print('Cuerpo de la respuesta: ${response.body}');
        _mostrarDialogoError(
            context, 'Error al iniciar sesión: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error al realizar la solicitud: $e');
      _mostrarDialogoError(context, 'Error al realizar la solicitud: $e');
    }
  }

  void _mostrarDialogoError(BuildContext context, String mensaje) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _claveController,
              decoration: InputDecoration(labelText: 'Clave'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Iniciar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
