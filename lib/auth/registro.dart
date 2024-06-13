import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:iniciofront/auth/login.dart';

class Registrar extends StatefulWidget {
  const Registrar({Key? key}) : super(key: key);

  @override
  State<Registrar> createState() => _RegistrarState();
}

class _RegistrarState extends State<Registrar> {
  final nombre = TextEditingController();
  final email = TextEditingController();
  final clave = TextEditingController();
  final confirmaClave = TextEditingController();
  bool invisibleClave = true;
  bool invisibleConfirmaClave = true;

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nombre.dispose();
    email.dispose();
    clave.dispose();
    confirmaClave.dispose();
    super.dispose();
  }

  Future<void> registrarUsuario() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.137.1:7777/api/autenticar/registrar'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombre': nombre.text,
          'email': email.text,
          'clave': clave.text,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['message'] == 'Usuario registrado exitosamente') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                data['message'],
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 255, 8),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ), // Color verde para éxito
              ),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPagina()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Error: ${data['message']}',
                style: const TextStyle(
                  color: Color.fromARGB(255, 255, 17, 0),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ), // Color rojo para error
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error al registrar usuario: ${response.reasonPhrase}',
              style: const TextStyle(
                color: Color.fromARGB(255, 255, 17, 0),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ), // Color rojo para error
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al registrar usuario:   $e',
            style: const TextStyle(
              color: Colors.red, // Color rojo para error
              fontWeight: FontWeight.bold, // Negrita
              fontSize: 18, // Tamaño de fuente más grande
            ),
          ),
        ),
      );
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
                  const Text(
                    "¡Regístrate y únete a nuestra comunidad!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Image.asset(
                    "assets/registrar.png",
                    width: 250,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: nombre,
                    hintText: "Nombres",
                    icon: FontAwesomeIcons.user,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Este campo es obligatorio";
                      }
                      if (!RegExp(r'^[a-zA-Z]+(\s[a-zA-Z]+)?$')
                          .hasMatch(value)) {
                        return "Por favor, introduce tu nombre y apellido";
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: email,
                    hintText: "Email",
                    icon: FontAwesomeIcons.envelope,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Este campo es obligatorio";
                      }
                      if (!EmailValidator.validate(value)) {
                        return "Por favor, introduce un correo electrónico válido";
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: clave,
                    hintText: "Contraseña",
                    icon: FontAwesomeIcons.lock,
                    obscureText: invisibleClave,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          invisibleClave = !invisibleClave;
                        });
                      },
                      icon: Icon(invisibleClave
                          ? FontAwesomeIcons.eye
                          : FontAwesomeIcons.eyeSlash),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Este campo es obligatorio";
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: confirmaClave,
                    hintText: "Confirma Clave",
                    icon: FontAwesomeIcons.lock,
                    obscureText: invisibleConfirmaClave,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          invisibleConfirmaClave = !invisibleConfirmaClave;
                        });
                      },
                      icon: Icon(invisibleConfirmaClave
                          ? FontAwesomeIcons.eye
                          : FontAwesomeIcons.eyeSlash),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Este campo es obligatorio";
                      }
                      if (value != clave.text) {
                        return "Las contraseñas no coinciden";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
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
                            registrarUsuario();
                          }
                        },
                        child: const Text(
                          "REGISTRAR",
                          style: TextStyle(
                            color: Color(0xffF2B90C),
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("¿Ya tienes una cuenta?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPagina()));
                        },
                        child: const Text(
                          "ACCEDER",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffBF8756)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    required String? Function(String?) validator,
  }) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.green.withOpacity(0.4),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          icon: Icon(icon),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: Color(0xff0E402E)),
          suffixIcon: suffixIcon,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffBF8756)),
          ),
        ),
        style: TextStyle(color: Color(0xff0E402E)),
      ),
    );
  }
}
//version login ultima actualizacion mejorada no cambiar