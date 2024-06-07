import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iniciofront/pages/home.dart';
import 'package:iniciofront/pages/profile.dart';
import 'package:iniciofront/pages/qualify.dart';
import 'package:iniciofront/pages/screens/reservas.dart';
import 'package:iniciofront/pages/search.dart';
import 'package:iniciofront/pages/trips.dart';

class BotonesNavegan extends StatefulWidget {
  const BotonesNavegan({Key? key}) : super(key: key);

  @override
  _BotonesNaveganState createState() => _BotonesNaveganState();
}

class _BotonesNaveganState extends State<BotonesNavegan> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    // Usa HomePage aquí
    HomePage(),
    ProfilePage(),
    QualifyPage(),
    SearchPage(),
    ViajePagina(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: GNav(
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey.shade800,
            gap: 5,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            padding: EdgeInsets.all(16),
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Inicio',
              ),
              GButton(
                icon: Icons.favorite,
                text: 'Favoritos',
              ),
              GButton(
                icon: Icons.search,
                text: 'Buscar',
              ),
              GButton(
                icon: Icons.save,
                text: 'Reservas',
              ),
              GButton(
                icon: Icons.settings,
                text: 'Configurar',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
