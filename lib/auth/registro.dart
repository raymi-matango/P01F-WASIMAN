import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:iniciofront/auth/login.dart';

class Registrar extends StatefulWidget {
  const Registrar({super.key});

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
        Uri.parse('http://localhost:7777/api/autenticar/registrar'),
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
            SnackBar(content: Text(data['message'])),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPagina()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${data['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Error al registrar usuario: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar usuario: $e')),
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
                    icon: Icons.person,
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
                    icon: Icons.email,
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
                    hintText: "Clave",
                    icon: Icons.lock,
                    obscureText: invisibleClave,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          invisibleClave = !invisibleClave;
                        });
                      },
                      icon: Icon(invisibleClave
                          ? Icons.visibility
                          : Icons.visibility_off),
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
                    icon: Icons.lock,
                    obscureText: invisibleConfirmaClave,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          invisibleConfirmaClave = !invisibleConfirmaClave;
                        });
                      },
                      icon: Icon(invisibleConfirmaClave
                          ? Icons.visibility
                          : Icons.visibility_off),
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
                      color: Colors.green,
                    ),
                    child: TextButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          registrarUsuario();
                        }
                      },
                      child: const Text(
                        "Registrar",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
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
                          style: TextStyle(fontWeight: FontWeight.bold),
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
        color: Colors.green.withOpacity(0.2),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          icon: Icon(icon),
          border: InputBorder.none,
          hintText: hintText,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
