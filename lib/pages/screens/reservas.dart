import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iniciofront/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReservaPagina extends StatefulWidget {
  final int viajeId;

  ReservaPagina({required this.viajeId});

  @override
  _ReservaPaginaState createState() => _ReservaPaginaState();
}

class _ReservaPaginaState extends State<ReservaPagina> {
  final _cantidadAsientosController = TextEditingController();

  Future<void> _reservarAsientos() async {
    final token = await TokenManager.getToken();
    final uri = Uri.parse('http://localhost:7777/api/reservas/crear');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'viajeId': widget.viajeId,
        'cantidadAsientos': int.parse(_cantidadAsientosController.text),
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reserva realizada con éxito')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error al realizar la reserva: ${response.body}')),
      );
    }
  }

  @override
  void dispose() {
    _cantidadAsientosController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservar Asientos'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Viaje ID: ${widget.viajeId}'),
            TextField(
              controller: _cantidadAsientosController,
              decoration: InputDecoration(labelText: 'Cantidad de Asientos'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _reservarAsientos,
              child: Text('Reservar'),
            ),
          ],
        ),
      ),
    );
  }
}
