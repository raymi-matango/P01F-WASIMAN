import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iniciofront/views/desplaza.ventana.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: DesplazaVentana(),
    );
  }
}
