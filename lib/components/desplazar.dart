import 'package:flutter/material.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      navigateRoute: SecondScreen(),
      duration: 3000,
      imageSize: 130,
      imageSrc: "logo.png",
      text: "WasimAn",
      textType: TextType.TyperAnimatedText,
      textStyle: TextStyle(
        fontSize: 30.0,
      ),
      backgroundColor: Colors.green, // Cambia el color de fondo a verde
    );
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Screen"),
      ),
      body: Center(
        child: Text("This is the second screen!"),
      ),
    );
  }
}
