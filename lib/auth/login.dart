import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:iniciofront/components/buttuns_navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:email_validator/email_validator.dart';
import 'package:iniciofront/auth/registro.dart';

class TokenManager {
  static const _key = 'jwt_token';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }

  static Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

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
        final token = responseData['token']; // Almacena el token JWT
        await TokenManager.saveToken(
            token); // Guarda el token en SharedPreferences
        setState(() {
          isLoggedIn = true; // El usuario ha iniciado sesión correctamente
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BotonesNavegan()),
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
                      color: Colors.green.withOpacity(0.4),
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
                        icon: FaIcon(
                          FontAwesomeIcons.envelope,
                          color: Color(0xff0E402E),
                        ),
                        border: InputBorder.none,
                        hintText: "Correo Electrónico",
                        hintStyle: TextStyle(color: Color(0xff0E402E)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffBF8756)),
                        ),
                      ),
                      style: TextStyle(color: Color(0xff0E402E)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.green.withOpacity(0.4),
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
                          icon: const FaIcon(
                            FontAwesomeIcons.lock,
                            color: Color(0xff0E402E),
                          ),
                          border: InputBorder.none,
                          hintText: "Contraseña",
                          hintStyle: const TextStyle(color: Color(0xff0E402E)),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffBF8756)),
                          ),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  invisible = !invisible;
                                });
                              },
                              icon: Icon(invisible
                                  ? FontAwesomeIcons.eye
                                  : FontAwesomeIcons.eyeSlash))),
                      style: const TextStyle(color: Color(0xff0E402E)),
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
                      color: Color(0xff0E402E),
                    ),
                    child: TextButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          _login();
                        }
                      },
                      child: const Text(
                        "INGRESAR",
                        style: TextStyle(
                          color: Color(0xffF2B90C),
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
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
                          style: TextStyle(
                            color: Color(0xffBF8756),
                            fontWeight: FontWeight.bold,
                          ),
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
