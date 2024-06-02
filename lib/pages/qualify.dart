import 'package:flutter/material.dart';

class QualifyPage extends StatefulWidget {
  const QualifyPage({super.key});

  @override
  State<QualifyPage> createState() => _HomePageState();
}

class _HomePageState extends State<QualifyPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Bienvendio a Calificacion de Kutik'),
      ),
    );
  }
}
