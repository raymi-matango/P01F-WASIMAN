import 'package:flutter/material.dart';

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
          padding: EdgeInsets.fromLTRB(12, 6, 0, 6),
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
        title: Text(
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
            padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
            child: IconButton(
              icon: Icon(
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
      body: Container(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Alinear los elementos a los extremos
                children: [
                  Text(
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
          ],
        ),
      ),
    );
  }
}
