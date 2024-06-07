import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iniciofront/pages/home.dart';
import 'package:iniciofront/pages/screens/detallesreservas.dart';
import 'package:iniciofront/pages/trips.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BotonesNavegan extends StatefulWidget {
  const BotonesNavegan({Key? key}) : super(key: key);

  @override
  _BotonesNaveganState createState() => _BotonesNaveganState();
}

class _BotonesNaveganState extends State<BotonesNavegan> {
  int _selectedIndex = 0;
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('jwt_token');
    });
  }

  void _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  void _deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }

  final List<Widget> _pages = [
    HomePage(),
    ViajePagina(),
    HomePage(),
    DetalleReserva(),
    HomePage(),
  ];

  @override
  Widget build(BuildContext context) {
    if (_token == null) {
      return Center(child: CircularProgressIndicator());
    }

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
                icon: Icons.car_crash,
                text: 'Mis viajes',
              ),
              GButton(
                icon: Icons.search,
                text: 'Buscar',
              ),
              GButton(
                icon: Icons.save,
                text: 'Mis reservas',
              ),
              GButton(
                icon: Icons.person,
                text: 'Perfil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
