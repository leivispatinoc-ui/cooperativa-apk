import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SolicitarViajeScreen extends StatefulWidget {
  const SolicitarViajeScreen({super.key});

  @override
  State<SolicitarViajeScreen> createState() => _SolicitarViajeScreenState();
}

class _SolicitarViajeScreenState extends State<SolicitarViajeScreen> {
  final _origenController = TextEditingController();
  final _destinoController = TextEditingController();

  void solicitarViaje(Map<String, dynamic> datosViaje) async {
    // 1. Guardamos en Firestore
    DocumentReference docRef = await FirebaseFirestore.instance.collection('viajes').add(datosViaje);
    
    // 2. Feedback visual
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Buscando motorizado en la COL...")),
    );
    
    print("Viaje publicado con ID: ${docRef.id}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pedir Viaje")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _origenController, decoration: const InputDecoration(labelText: "Origen")),
            TextField(controller: _destinoController, decoration: const InputDecoration(labelText: "Destino")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                solicitarViaje({
                  'cliente_id': FirebaseAuth.instance.currentUser!.uid,
                  'origen': _origenController.text,
                  'destino': _destinoController.text,
                  'precio_actual': 'Calculando...',
                  'estado': 'pendiente',
                  'latitud': 10.64, // Coordenada base
                  'longitud': -71.62,
                  'timestamp': FieldValue.serverTimestamp(),
                });
              },
              child: const Text("SOLICITAR VIAJE"),
            ),
          ],
        ),
      ),
    );
  }
}