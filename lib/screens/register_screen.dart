import 'package:financial/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              child: Text('Registrarse'),
              onPressed: () async {
                final user = await authService.registerWithEmailAndPassword(
                  _emailController.text,
                  _passwordController.text,
                );
                if (user != null) {
                  // Navegar a la pantalla principal
                  Navigator.pushReplacementNamed(context, '/home');
                } else {
                  // Mostrar error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al registrarse')),
                  );
                }
              },
            ),
            TextButton(
              child: Text('¿Ya tienes una cuenta? Inicia sesión'),
              onPressed: () {
                // Volver a la pantalla de inicio de sesión
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}