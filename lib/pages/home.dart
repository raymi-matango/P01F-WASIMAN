import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0E402E),
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(12, 6, 0, 6),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Color(0x4D9489F5),
              shape: BoxShape.circle,
              border: Border.all(
                color: Color(0xFFF29F05),
                width: 2,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(2),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  'https://picsum.photos/seed/626/600',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        title: const Text(
          'Bienvenido, Kutik',
          style: TextStyle(
            fontFamily: 'Outfit',
            color: Color(0xFFF2B90C),
            fontSize: 24,
            letterSpacing: 0,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
            child: IconButton(
              icon: const Icon(
                Icons.notifications_active,
                color: Color(0xFFF2B90C),
                size: 24,
              ),
              onPressed: () {
                print('IconButton pressed ...');
              },
            ),
          ),
        ],
        centerTitle: false,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              //este de aqui esta el boton para que se vaya a los viajes
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Alinear los elementos a los extremos
                  children: [
                    const Text(
                      '  Elige tu destino',
                      style: TextStyle(
                        fontFamily: 'Readex Pro',
                        fontSize: 20,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Spacer(), // Espacio flexible para empujar el texto a la izquierda
                    InkWell(
                      onTap: () {
                        // Acción al presionar el botón "Ver todos"
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Ver todos',
                              style: TextStyle(
                                fontFamily: 'Readex Pro',
                                letterSpacing: 0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_sharp,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //carrusel:
              const SizedBox(
                height: 15,
              ),
              Container(
                height: 200, // Altura del contenedor del carrusel
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 290, // Altura del carrusel
                    enlargeCenterPage: true,
                    autoPlay: true,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    viewportFraction: 0.8,
                  ),
                  items: [
                    'assets/imagen1-home.jpg',
                    'assets/imagen6-home.jpg',
                    'assets/imagen7-home.jpg',
                    'assets/imagen8-home.jpg',
                    'assets/imagen3-home.jpg',
                    'assets/imagen5-home.jpg',
                    'assets/imagen4-home.jpg',
                    'assets/imagen2-home.jpg',
                    'assets/imagen9-home.jpg',
                  ].map((item) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                                16.0), // Radio del borde circular
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Image.asset(
                              item,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              const Text(
                'Planea tu viaje',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              //Caja de botones
              Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.symmetric(vertical: 4, horizontal: 40),
                decoration: BoxDecoration(
                  color: Color.fromARGB(
                      255, 3, 46, 82), // Color de fondo del contenedor
                  borderRadius: BorderRadius.circular(20), // Bordes redondeados
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.5), // Sombra naranja
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 2), // Desplazamiento de la sombra
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDestination(
                          '   Destinos   ',
                          FontAwesomeIcons.car,
                          onTap: () {
                            // Acción al hacer clic en Destino 1
                            print('Clic en Destino 1');
                          },
                        ),
                        _buildDestination(
                          'Comentarios',
                          FontAwesomeIcons.plane,
                          onTap: () {
                            // Acción al hacer clic en Destino 2
                            print('Clic en Destino 2');
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDestination(
                          '   Reservas   ',
                          FontAwesomeIcons.train,
                          onTap: () {
                            // Acción al hacer clic en Destino 3
                            print('Clic en Destino 3');
                          },
                        ),
                        _buildDestination(
                          ' Disponibles  ',
                          FontAwesomeIcons.bus,
                          onTap: () {
                            // Acción al hacer clic en Destino 4
                            print('Clic en Destino 4');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              //boton de reserva ahora
              Container(
                width: 300,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Color(0xFFF29F05),
                    width: 1,
                  ),
                  color: Color(0xFF0E402E),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      offset: Offset(0, 3),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () {
                    print('Button pressed ...');
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    backgroundColor: Colors.transparent,
                  ),
                  child: const Text(
                    '¡Reserva Ahora!',
                    style: TextStyle(
                      fontFamily: 'Readex Pro',
                      color: Colors.white,
                      letterSpacing: 0,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDestination(String name, IconData iconData,
      {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 10), // Ajusta el espacio horizontal
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.all(5),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
            const Color.fromARGB(255, 99, 4, 4),
          ),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return const Color.fromARGB(255, 6, 117, 10);
              }
              return null;
            },
          ),
          elevation: MaterialStateProperty.resolveWith<double>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return 6; // Elevación cuando se presiona
              }
              return 3; // Elevación predeterminada
            },
          ),
          shadowColor: MaterialStateProperty.all<Color>(
            const Color.fromARGB(255, 92, 226, 126).withOpacity(0.5),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontFamily: 'Font Awesome',
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 97, 244, 6),
              ),
            ),
            const SizedBox(height: 10),
            Icon(
              iconData,
              size: 50,
              color: const Color.fromARGB(255, 129, 54, 54),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
