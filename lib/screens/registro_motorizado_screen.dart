import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class RegistroMotorizadoScreen extends StatefulWidget {
  const RegistroMotorizadoScreen({super.key});

  @override
  State<RegistroMotorizadoScreen> createState() => _RegistroMotorizadoScreenState();
}

class _RegistroMotorizadoScreenState extends State<RegistroMotorizadoScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _nombre = TextEditingController();
  bool _obscureText = true;
  bool _cargando = false;
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  Future<void> _registrar() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Debes subir una foto de tu documento")));
      return;
    }

    setState(() => _cargando = true);
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email.text.trim(), password: _password.text.trim());

      final ref = FirebaseStorage.instance.ref().child('documentos/${userCredential.user!.uid}');
      await ref.putFile(_image!);
      String imageUrl = await ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('motorizados').doc(userCredential.user!.uid).set({
        'nombre': _nombre.text.trim(),
        'email': _email.text.trim(),
        'aprobado': false,
        'documento_url': imageUrl,
      });
      
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registro Motorizado")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _nombre, decoration: const InputDecoration(labelText: "Nombre")),
            TextField(controller: _email, decoration: const InputDecoration(labelText: "Correo")),
            TextField(
              controller: _password,
              obscureText: _obscureText,
              decoration: InputDecoration(
                labelText: "Contraseña",
                suffixIcon: IconButton(
                  icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _pickImage, child: const Text("Subir Documento")),
            if (_image != null) const Text("Documento seleccionado", style: TextStyle(color: Colors.green)),
            const SizedBox(height: 20),
            _cargando 
              ? const CircularProgressIndicator() 
              : ElevatedButton(onPressed: _registrar, child: const Text("REGISTRAR")),
          ],
        ),
      ),
    );
  }
}