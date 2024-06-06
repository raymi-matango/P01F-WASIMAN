import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:iniciofront/auth/registro.dart';
import 'package:iniciofront/pages/trips.dart';

class LoginPagina extends StatefulWidget {
  const LoginPagina({Key? key}) : super(key: key);

  @override
  State<LoginPagina> createState() => _LoginPaginaState();
}

class _LoginPaginaState extends State<LoginPagina> {
  final email = TextEditingController();
  final clave = TextEditingController();
  bool invisible = true;
  final formKey = GlobalKey<FormState>();
  bool isLoggedIn = false;
  String? token;

  @override
  void dispose() {
    email.dispose();
    clave.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final uri = Uri.parse("http://localhost:7777/api/autenticar/login");
    try {
      final response = await http.post(
        uri,
        body: json.encode({
          "email": email.text,
          "clave": clave.text,
        }),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        token = responseData['token']; // Almacena el token JWT
        setState(() {
          isLoggedIn = true; // El usuario ha iniciado sesión correctamente
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ViajePagina()),
        );
      } else if (response.statusCode == 400) {
        final error = json.decode(response.body)["mensaje"];
        _showErrorMessage(error);
      } else if (response.statusCode == 404) {
        _showErrorMessage("Email no encontrado");
      } else if (response.statusCode == 401) {
        _showErrorMessage("Contraseña incorrecta");
      } else {
        _showErrorMessage(
            "Error al autenticar, por favor inténtalo de nuevo más tarde");
      }
    } catch (e) {
      _showErrorMessage(
          "Error al autenticar, por favor inténtalo de nuevo más tarde: $e");
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 1, 20, 6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Image.asset(
                    "assets/login.png",
                    width: 250,
                  ),
                  Container(
                    margin: EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.green.withOpacity(0.2),
                    ),
                    child: TextFormField(
                      controller: email,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Este campo es obligatorio";
                        }
                        if (!EmailValidator.validate(value)) {
                          return "Por favor, introduce un correo electrónico válido";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.email),
                        border: InputBorder.none,
                        hintText: "Email",
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.green.withOpacity(0.2),
                    ),
                    child: TextFormField(
                      controller: clave,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Este campo es obligatorio";
                        }
                        return null;
                      },
                      obscureText: invisible,
                      decoration: InputDecoration(
                          icon: Icon(Icons.lock),
                          border: InputBorder.none,
                          hintText: "Clave",
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  invisible = !invisible;
                                });
                              },
                              icon: Icon(invisible
                                  ? Icons.visibility
                                  : Icons.visibility_off))),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.green,
                    ),
                    child: TextButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          _login();
                        }
                      },
                      child: const Text(
                        "Acceder",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("¿Nuevo por aquí? ¡Crea tu cuenta!"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Registrar()));
                        },
                        child: const Text(
                          "REGÍSTRATE",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
