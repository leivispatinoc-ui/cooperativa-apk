import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatViajeScreen extends StatefulWidget {
  final String nombreChat;
  final String idViaje;

  const ChatViajeScreen({
    super.key,
    required this.nombreChat,
    required this.idViaje,
  });

  @override
  State<ChatViajeScreen> createState() => _ChatViajeScreenState();
}

class _ChatViajeScreenState extends State<ChatViajeScreen> {
  final TextEditingController _mensajeController = TextEditingController();
  final String _currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';

  void _enviarMensaje() async {
    String texto = _mensajeController.text.trim();
    if (texto.isEmpty || widget.idViaje.isEmpty) return;

    _mensajeController.clear();

    try {
      await FirebaseFirestore.instance
          .collection('viajes')
          .doc(widget.idViaje)
          .collection('chat')
          .add({
        'remitenteId': _currentUid,
        'texto': texto,
        'fecha': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Evita caídas silenciosas si falla la red
      debugPrint("Error al enviar mensaje: $e");
    }
  }

  @override
  void dispose() {
    _mensajeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nombreChat),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('viajes')
                  .doc(widget.idViaje)
                  .collection('chat')
                  .orderBy('fecha', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Error al cargar el chat"));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var documentos = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: documentos.length,
                  itemBuilder: (context, index) {
                    var datos = documentos[index].data() as Map<String, dynamic>;
                    bool esMio = datos['remitenteId'] == _currentUid;

                    return Align(
                      alignment: esMio ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: esMio ? Colors.amber[200] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(datos['texto'] ?? ''),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Caja de texto protegida para evitar colisiones con la barra del sistema
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.blue.shade100),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _mensajeController,
                      decoration: const InputDecoration(
                        hintText: "Escribe un mensaje...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.black),
                    onPressed: _enviarMensaje,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}