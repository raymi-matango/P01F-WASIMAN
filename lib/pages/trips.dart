import 'package:flutter/material.dart';
import 'package:iniciofront/auth/login.dart';

class ViajePagina extends StatefulWidget {
  const ViajePagina({Key? key}) : super(key: key);

  @override
  State<ViajePagina> createState() => _ViajePaginaState();
}

class _ViajePaginaState extends State<ViajePagina> {
  String? token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final retrievedToken = await TokenManager.getToken();
    setState(() {
      token = retrievedToken;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Viaje Página'),
      ),
      body: Center(
        child: token != null
            ? Text('Token: $token')
            : CircularProgressIndicator(), // Muestra un indicador de carga mientras se obtiene el token
      ),
    );
  }
}
