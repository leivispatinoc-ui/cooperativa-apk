import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistroClienteScreen extends StatefulWidget {
  const RegistroClienteScreen({super.key});

  @override
  State<RegistroClienteScreen> createState() => _RegistroClienteScreenState();
}

class _RegistroClienteScreenState extends State<RegistroClienteScreen> {
  final TextEditingController _nombre = TextEditingController();
  final TextEditingController _cedula = TextEditingController();
  final TextEditingController _celular = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  bool _cargando = false;

  Future<void> _registrarCliente() async {
    if (_nombre.text.isEmpty || _cedula.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, llena los campos requeridos")),
      );
      return;
    }
    
    setState(() => _cargando = true);
    
    try {
      await FirebaseFirestore.instance.collection('usuarios').doc(_cedula.text).set({
        'nombre': _nombre.text,
        'cedula': _cedula.text,
        'celular': _celular.text,
        'rol': 'CLIENTE',
        'contrasena': _pass.text,
      });
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    } finally {
      if (mounted) {
        setState(() => _cargando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registro de Cliente")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const TextField(decoration: InputDecoration(labelText: "Nombre Completo")),
            // Nota: Asigné el controlador en los campos para que funcionen
            TextField(controller: _nombre, decoration: const InputDecoration(labelText: "Nombre Completo")),
            TextField(controller: _cedula, decoration: const InputDecoration(labelText: "Cédula")),
            TextField(controller: _celular, decoration: const InputDecoration(labelText: "Celular")),
            TextField(controller: _pass, obscureText: true, decoration: const InputDecoration(labelText: "Contraseña")),
            const SizedBox(height: 30),
            _cargando 
                ? const CircularProgressIndicator() 
                : ElevatedButton(
                    onPressed: _registrarCliente,
                    style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                    child: const Text("REGISTRAR CLIENTE"),
                  ),
          ],
        ),
      ),
    );
  }
}