import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:iniciofront/auth/registro.dart';
import 'package:iniciofront/pages/wasi.dart'; // Importa la página de inicio

class LoginPagina extends StatefulWidget {
  const LoginPagina({Key? key}) : super(key: key);

  @override
  State<LoginPagina> createState() => _LoginPaginaState();
}

class _LoginPaginaState extends State<LoginPagina> {
  final email = TextEditingController();
  final clave = TextEditingController();
  bool invisible = false;
  final formKey = GlobalKey<FormState>();

  Future<void> _login() async {
    final uri = Uri.parse("http://localhost:7777/api/autenticar/login");
    final response = await http.post(
      uri,
      body: json.encode({
        "email": email.text,
        "clave": clave.text,
      }),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      // Si la autenticación fue exitosa, redirige a la página de inicio
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (response.statusCode == 400) {
      // Si hubo un error de validación en la API, muestra el mensaje de error recibido
      final error = json.decode(response.body)["mensaje"];
      print("Error de validación: $error");
    } else {
      // Si ocurrió algún otro error, muestra un mensaje genérico
      print("Error al autenticar, por favor inténtalo de nuevo más tarde");
    }
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
                      onPressed: _login,
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
