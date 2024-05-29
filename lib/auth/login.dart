import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class LoginPagina extends StatefulWidget {
  const LoginPagina({super.key});

  @override
  State<LoginPagina> createState() => _LoginPaginaState();
}

class _LoginPaginaState extends State<LoginPagina> {
  final email = TextEditingController();
  final clave = TextEditingController();
  bool invisible = false;
  //Global
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
                  //Logo
                  Image.asset(
                    "assets/login.png",
                    width: 250,
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
                        onPressed: () {},
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
