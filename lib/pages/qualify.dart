import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CatCard extends StatelessWidget {
  const CatCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                NextPage(), // Reemplaza NextPage() con tu página destino
          ),
        );
      },
      child: Column(
        children: [
          _buildCardRow(
            imageUrl: 'https://i.ibb.co/4YDz5FF/estudiante1.jpg',
            stars: '4.5',
            userName: 'Pablo Fernando',
            location: 'Carcelen',
          ),
          _buildCardRow(
            imageUrl: 'https://i.ibb.co/4YDz5FF/estudiante1.jpg',
            stars: '4.7',
            userName: 'Juan Perez',
            location: 'Quito',
          ),
          // Agrega más filas de tarjetas aquí según sea necesario
        ],
      ),
    );
  }

  Widget _buildCardRow({
    required String imageUrl,
    required String stars,
    required String userName,
    required String location,
  }) {
    return Row(
      children: [
        Expanded(
          child: _buildCatCardItem(
            imageUrl: imageUrl,
            stars: stars,
            userName: userName,
            location: location,
          ),
        ),
        SizedBox(width: 8), // Espaciado entre las tarjetas
        Expanded(
          child: _buildCatCardItem(
            imageUrl: imageUrl,
            stars: stars,
            userName: userName,
            location: location,
          ),
        ),
      ],
    );
  }

  Widget _buildCatCardItem({
    required String imageUrl,
    required String stars,
    required String userName,
    required String location,
  }) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Image.network(
                imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.solidStar,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      stars,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: 8,
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.userTie,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      userName,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          ListTile(
            title: Text(
              location,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
          ),
        ],
      ),
    );
  }
}

class NextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Next Page'),
      ),
      body: Center(
        child: Text('This is the next page!'),
      ),
    );
  }
}
