import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:iniciofront/auth/login.dart';

class Registrar extends StatefulWidget {
  const Registrar({Key? key}) : super(key: key);

  @override
  State<Registrar> createState() => _RegistrarState();
}

class _RegistrarState extends State<Registrar> {
  final nombreController = TextEditingController();
  final emailController = TextEditingController();
  final claveController = TextEditingController();
  final confirmarClaveController = TextEditingController();
  bool mostrarClave = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> _registrarUsuario() async {
    final url = Uri.parse("http://localhost:7777/api/autenticar/registrar");
    final response = await http.post(
      url,
      body: {
        "nombre": nombreController.text,
        "email": emailController.text,
        "clave": claveController.text,
      },
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("¡Registro exitoso! Por favor, inicia sesión.")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPagina()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Error al registrar usuario. Por favor, inténtalo de nuevo.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registro de Usuario")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "¡Regístrate y únete a nuestra comunidad!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: nombreController,
                decoration: InputDecoration(
                  labelText: "Nombres",
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Por favor, ingresa tu nombre";
                  }
                  return null;
                },
              ),
              SizedBox(height: 12.0),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Correo Electrónico",
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Por favor, ingresa tu correo electrónico";
                  }
                  if (!EmailValidator.validate(value)) {
                    return "Por favor, ingresa un correo electrónico válido";
                  }
                  return null;
                },
              ),
              SizedBox(height: 12.0),
              TextFormField(
                controller: claveController,
                obscureText: !mostrarClave,
                decoration: InputDecoration(
                  labelText: "Contraseña",
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        mostrarClave = !mostrarClave;
                      });
                    },
                    icon: Icon(
                        mostrarClave ? Icons.visibility : Icons.visibility_off),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Por favor, ingresa tu contraseña";
                  }
                  return null;
                },
              ),
              SizedBox(height: 12.0),
              TextFormField(
                controller: confirmarClaveController,
                obscureText: !mostrarClave,
                decoration: InputDecoration(
                  labelText: "Confirmar Contraseña",
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        mostrarClave = !mostrarClave;
                      });
                    },
                    icon: Icon(
                        mostrarClave ? Icons.visibility : Icons.visibility_off),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Por favor, confirma tu contraseña";
                  }
                  if (value != claveController.text) {
                    return "Las contraseñas no coinciden";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _registrarUsuario();
                  }
                },
                child: Text("Registrar"),
              ),
              SizedBox(height: 12.0),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPagina()),
                  );
                },
                child: Text("¿Ya tienes una cuenta? Inicia Sesión"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
