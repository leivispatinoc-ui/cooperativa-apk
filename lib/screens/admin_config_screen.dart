import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminConfigScreen extends StatelessWidget {
  final TextEditingController _baseController = TextEditingController();
  final TextEditingController _kmController = TextEditingController();
  final TextEditingController _tasaController = TextEditingController();

  AdminConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Panel del Dueño")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _baseController, decoration: InputDecoration(labelText: "Tarifa Base (\$)", border: OutlineInputBorder())),
            TextField(controller: _kmController, decoration: InputDecoration(labelText: "Costo por KM (\$)", border: OutlineInputBorder())),
            TextField(controller: _tasaController, decoration: InputDecoration(labelText: "Tasa BCV Actual", border: OutlineInputBorder())),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('config').doc('precios').set({
                  'base': double.tryParse(_baseController.text) ?? 0.0,
                  'km': double.tryParse(_kmController.text) ?? 0.0,
                  'tasa_bcv': double.tryParse(_tasaController.text) ?? 0.0,
                });
              },
              child: Text("Guardar Configuración"),
            ),
            Divider(height: 40),
            Text("Motorizados Pendientes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('motorizados').where('aprobado', isEqualTo: false).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var doc = snapshot.data!.docs[index];
                    return ListTile(
                      title: Text(doc['nombre']),
                      trailing: IconButton(
                        icon: Icon(Icons.check_circle, color: Colors.green),
                        onPressed: () => doc.reference.update({'aprobado': true}),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}