import 'package:flutter/material.dart';

class Registrar extends StatefulWidget {
  const Registrar({super.key});

  @override
  State<Registrar> createState() => _RegistrarState();
}

class _RegistrarState extends State<Registrar> {
  final email = TextEditingController();
  final clave = TextEditingController();
  final confirmaClave = TextEditingController();

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          //nosotros
        ],
      ),
    );
  }
}
