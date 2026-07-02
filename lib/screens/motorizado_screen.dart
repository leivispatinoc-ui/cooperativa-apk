import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MotorizadoScreen extends StatefulWidget {
  const MotorizadoScreen({super.key});

  @override
  State<MotorizadoScreen> createState() => _MotorizadoScreenState();
}

class _MotorizadoScreenState extends State<MotorizadoScreen> {
  
  // En una versión avanzada, aquí se integra el cálculo real con Google Maps API
  String _calcularETA() => "5 min"; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Viajes Disponibles")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('viajes')
            .where('estado', isEqualTo: 'buscando')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          final viajes = snapshot.data!.docs;

          if (viajes.isEmpty) {
            return const Center(child: Text("Esperando nuevas solicitudes..."));
          }

          return ListView.builder(
            itemCount: viajes.length,
            itemBuilder: (context, index) {
              var viaje = viajes[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text("Origen: ${viaje['origen']}"),
                  subtitle: Text("Destino: ${viaje['destino']}\nETA: ${_calcularETA()}"),
                  trailing: ElevatedButton(
                    onPressed: () {
                      viaje.reference.update({
                        'estado': 'en_camino',
                        'tiempo_llegada': _calcularETA(),
                      });
                    },
                    child: const Text("Aceptar"),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}