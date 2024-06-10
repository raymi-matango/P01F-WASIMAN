import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CatCard extends StatelessWidget {
  const CatCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Image.network(
                'https://i.ibb.co/4YDz5FF/estudiante1.jpg',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star, // Placeholder for rating icon
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '4.5', // Placeholder for rating
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                //Demuestra si esta disponible o no disponible
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
                      Icons.person, // Placeholder for user icon
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Nombre del usuario', // Placeholder for username
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
              'Destino', // Placeholder for destination
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
