import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iniciofront/pages/home.dart';
import 'package:iniciofront/pages/qualify.dart';
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
        color: Colors.white70,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
          child: GNav(
            backgroundColor: Colors.white10,
            color: Color(0xff0E402E),
            activeColor: Color(0xff0E402E),
            tabBackgroundColor: Color(0xffF2B90C),
            gap: 5,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            padding: EdgeInsets.all(16),
            tabs: const [
              GButton(
                icon: FontAwesomeIcons.house,
                text: ' Inicio',
              ),
              GButton(
                icon: FontAwesomeIcons.magnifyingGlassLocation,
                text: ' Buscar',
              ),
              GButton(
                icon: FontAwesomeIcons.carSide,
                text: ' Mis reservas',
              ),
              GButton(
                icon: FontAwesomeIcons.userLarge,
                text: ' Perfil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
