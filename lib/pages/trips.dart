import 'package:flutter/material.dart';

class TripsPage extends StatefulWidget {
  const TripsPage({super.key});

  @override
  State<TripsPage> createState() => _HomePageState();
}

class _HomePageState extends State<TripsPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Bienvendio a Mis Viajes Realizados de Kutik'),
      ),
    );
  }
}
