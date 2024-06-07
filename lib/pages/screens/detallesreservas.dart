import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iniciofront/pages/screens/reservas.dart';
import 'package:url_launcher/url_launcher.dart';

class DetalleReserva extends StatefulWidget {
  const DetalleReserva({super.key});

  @override
  State<DetalleReserva> createState() => _DetalleReservaState();
}

class _DetalleReservaState extends State<DetalleReserva> {
  List<dynamic> reservas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReservas();
  }

  Future<void> _fetchReservas() async {
    final token = await TokenManager.getToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Token no disponible. Por favor, inicie sesión de nuevo.')),
      );
      return;
    }

    final uri = Uri.parse('http://192.168.137.1:7777/api/reservas/detalles');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        reservas = responseData['reservas'];
        _isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error al cargar las reservas: ${response.body}')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _cancelarReserva(int reservaId) async {
    final token = await TokenManager.getToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Token no disponible. Por favor, inicie sesión de nuevo.')),
      );
      return;
    }

    final uri =
        Uri.parse('http://192.168.137.1:7777/api/reservas/cancelar/$reservaId');
    final response = await http.delete(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        reservas.removeWhere((reserva) => reserva['id'] == reservaId);
      });
      _mostrarDialogoExito();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error al cancelar la reserva: ${response.body}')),
      );
    }
  }

  void _mostrarDialogoExito() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 60),
              SizedBox(height: 20),
              Text(
                'Reserva cancelada con éxito',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        );
      },
    );

    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  void _abrirChatWhatsApp(String mensaje) async {
    final whatsappUrl = 'https://wa.me/?text=$mensaje';
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se puede abrir WhatsApp')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de Reservas'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchReservas,
              child: ListView.builder(
                itemCount: reservas.length,
                itemBuilder: (context, index) {
                  final reserva = reservas[index];
                  return ListTile(
                    title: Text('Viaje ID: ${reserva['viajeId']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Cantidad de Asientos: ${reserva['cantidadAsientos']}'),
                        Text(
                            'Fecha y Hora de Reserva: ${reserva['fechaHoraReserva']}'),
                        Text('Estado de Reserva: ${reserva['estadoReserva']}'),
                      ],
                    ),
                    trailing: reserva['estadoReserva'] == 'pendiente'
                        ? IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                _confirmarCancelacionReserva(reserva['id']),
                          )
                        : IconButton(
                            icon: Icon(Icons.telegram, color: Colors.green),
                            onPressed: () => _abrirChatWhatsApp(
                                'Detalles de la reserva: ${reserva['id']}'),
                          ),
                  );
                },
              ),
            ),
    );
  }

  void _confirmarCancelacionReserva(int reservaId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar Cancelación'),
        content: Text('¿Estás seguro de que deseas cancelar esta reserva?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _cancelarReserva(reservaId);
            },
            child: Text('Sí'),
          ),
        ],
      ),
    );
  }
}
