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
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _nombre = TextEditingController();
  bool _obscureText = true;
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) setState(() => _image = File(pickedFile.path));
  }

  void _registrar() async {
    try {
      UserCredential user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email.text, password: _password.text);
      
      String? imageUrl;
      if (_image != null) {
        final ref = FirebaseStorage.instance.ref().child('documentos/${user.user!.uid}');
        await ref.putFile(_image!);
        imageUrl = await ref.getDownloadURL();
      }

      await FirebaseFirestore.instance.collection('motorizados').doc(user.user!.uid).set({
        'nombre': _nombre.text,
        'email': _email.text,
        'aprobado': false,
        'documento_url': imageUrl,
      });
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
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
            TextButton(
              onPressed: () => FirebaseAuth.instance.sendPasswordResetEmail(email: _email.text),
              child: const Text("¿Olvidaste tu contraseña?"),
            ),
            ElevatedButton(onPressed: _pickImage, child: const Text("Subir Documento")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _registrar, child: const Text("REGISTRAR")),
          ],
        ),
      ),
    );
  }
}