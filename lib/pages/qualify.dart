import 'package:flutter/material.dart';

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
                height: 150,
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
                  child: const Text(
                    '45',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Column(
                  children: const [
                    CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.person), // Icono de usuario
            title: const Text('Usuario'), // Nombre del usuario
            subtitle: const Text('Barcelona'), // Subtítulo
          ),
        ],
      ),
    );
  }
}
