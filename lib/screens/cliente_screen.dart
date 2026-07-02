import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClienteScreen extends StatefulWidget {
  final String viajeId;
  const ClienteScreen({super.key, required this.viajeId});

  @override
  State<ClienteScreen> createState() => _ClienteScreenState();
}

class _ClienteScreenState extends State<ClienteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Viaje en Curso")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('viajes').doc(widget.viajeId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          var data = snapshot.data!.data() as Map<String, dynamic>;
          
          return Stack(
            children: [
              FlutterMap(
                options: MapOptions(initialCenter: LatLng(data['latitud'], data['longitud']), initialZoom: 16),
                children: [
                  TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
                  MarkerLayer(markers: [
                    Marker(point: LatLng(data['latitud'], data['longitud']), child: const Icon(Icons.motorcycle, color: Colors.red, size: 40)),
                  ]),
                ],
              ),
              Positioned(
                bottom: 20,
                left: 20,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  color: Colors.white,
                  child: Text(
                    "Precio Actual: Bs ${data['precio_actual']}",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}