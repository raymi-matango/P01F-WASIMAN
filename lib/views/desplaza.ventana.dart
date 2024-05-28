import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iniciofront/utils/global.color.dart';
import 'package:iniciofront/views/login.ventana.dart';

class DesplazaVentana extends StatefulWidget {
  const DesplazaVentana({super.key});

  @override
  State<DesplazaVentana> createState() => _DesplazaVentanaState();
}

class _DesplazaVentanaState extends State<DesplazaVentana> {
  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 3), () {
      Get.to(LoginVentana());
    });
    return Scaffold(
      backgroundColor: GlobalColors.mainColor,
      body: const Center(
        child: Text(
          'WasimAn',
          style: TextStyle(
            color: Colors.white,
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
