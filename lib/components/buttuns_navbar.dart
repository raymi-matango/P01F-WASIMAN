import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iniciofront/pages/home.dart';
import 'package:iniciofront/pages/profile.dart';
import 'package:iniciofront/pages/qualify.dart';
import 'package:iniciofront/pages/search.dart';
import 'package:iniciofront/pages/trips.dart';

class ButtonsNavBarPage extends StatefulWidget {
  const ButtonsNavBarPage({super.key});

  @override
  State<ButtonsNavBarPage> createState() => _ButtonsNavBarState();
}

class _ButtonsNavBarState extends State<ButtonsNavBarPage> {
  int myIndex = 0;
  List pages = const [
    ProfilePage(),
    QualifyPage(),
    SearchPage(),
    TripsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black, //quitar
        bottomNavigationBar: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
                color: Color.fromARGB(66, 18, 123, 215),
                blurRadius: 30,
                offset: Offset(0, 20))
          ]),
          child: ClipRRect(
            borderRadius: BorderRadiusDirectional.circular(25),
            child: BottomNavigationBar(
              currentIndex: myIndex,
              backgroundColor: Colors.black12,
              selectedItemColor: Color.fromARGB(255, 10, 121, 3),
              unselectedItemColor: Color.fromARGB(255, 25, 0, 107),
              selectedFontSize: 15,
              showSelectedLabels: true,
              showUnselectedLabels: false,
              onTap: (index) {
                setState(() {
                  myIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.house), label: 'Inicio'),
                BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.carSide), label: 'Viajes'),
                BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.magnifyingGlassLocation),
                    label: 'Buscar'),
                BottomNavigationBarItem(
                    icon: FaIcon(
                      FontAwesomeIcons.star,
                    ),
                    label: 'Calificación'),
                BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.userLarge), label: 'Perfil'),
              ],
            ),
          ),
        ),
        body: pages[myIndex]);
  }
}
