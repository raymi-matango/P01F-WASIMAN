import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
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
  bool invisible = false;

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            //Controladores
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
                  //Logo
                  Image.asset(
                    "assets/registrar.png",
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
                      controller: nombre,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Este campo es obligatorio";
                        }
                        if (!RegExp(r'^[a-zA-Z]+(\s[a-zA-Z]+)?$')
                            .hasMatch(value)) {
                          return "Por favor, introduce tu nombre";
                        }
                        return null; // Devuelve null si la validación es exitosa
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        border: InputBorder.none,
                        hintText: "Nombres",
                      ),
                    ),
                  ),
                  //Usuario en este caso debe ser email
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
                        return null; // Devuelve null si la validación es exitosa
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.email),
                        border: InputBorder.none,
                        hintText: "Email",
                      ),
                    ),
                  ),

                  //Constrasenia
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
                  //Boton para ingresar
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
                          //metodo que ingrese
                        }
                      },
                      child: const Text(
                        "Registrar",
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
