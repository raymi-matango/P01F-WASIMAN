import 'package:flutter/material.dart';

class ConductorDetalle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalle de Viaje')),
      body: Padding(
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
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDataRow('Destino:', 'Ciudad B'),
                    _buildDataRow('Origen:', 'Ciudad A'),
                    _buildDataRow(
                        'Hora:', ''), // Puedes dejar este espacio en blanco
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text('', style: TextStyle(fontSize: 16)),
                        SizedBox(width: 10),
                        _buildStarRating(4.5),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            // Acción al presionar el botón de calificar
                          },
                          child: Text('Calificar'),
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
            _buildDataRow('Nombre:', ''),
            _buildDataRow('Correo:', ''),
            _buildDataRow('Facultad:', ''),
            _buildDataRow('Teléfono:', ''),
            SizedBox(height: 20),
            Text('Comentarios:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            // Aquí iría el ListView.builder para mostrar los comentarios
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Acción al presionar el botón de reserva
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
        Icon(Icons.star, color: Colors.yellow),
        SizedBox(width: 5),
        Text(rating.toString(), style: TextStyle(fontSize: 16)),
      ],
    );
  }
}
