import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'nueva_poliza_screen.dart';
import 'editar_poliza_screen.dart';

class PolizasScreen extends StatefulWidget {
  @override
  _PolizasScreenState createState() => _PolizasScreenState();
}

class _PolizasScreenState extends State<PolizasScreen> {
  final ApiService apiService = ApiService();
  List<dynamic> polizas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    cargarPolizas();
  }

  void cargarPolizas() async {
    try {
      final datos = await apiService.getPolizas();
      setState(() {
        polizas = datos;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al obtener las pólizas")),
      );
    }
  }

  void eliminarPoliza(int id) async {
    await apiService.deletePoliza(id);
    setState(() {
      polizas.removeWhere((poliza) => poliza['id'] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Póliza eliminada correctamente"), backgroundColor: Colors.green),
    );
  }

  void irANuevaPolizaScreen() async {
    final nuevaPoliza = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NuevaPolizaScreen()),
    );

    if (nuevaPoliza != null) {
      setState(() {
        polizas.add(nuevaPoliza);
      });
    }
  }

  void irAEditarPolizaScreen(Map<String, dynamic> poliza) async {
  final polizaActualizada = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EditarPolizaScreen(poliza: poliza),
    ),
  );

  if (polizaActualizada != null) {
    cargarPolizas(); // 🔄 Recargar la lista completa después de editar
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pólizas"),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue,
                side: BorderSide(color: Colors.blue),
              ),
              icon: Icon(Icons.add, color: Colors.blue),
              label: Text("Agregar"),
              onPressed: irANuevaPolizaScreen,
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : polizas.isEmpty
              ? Center(
                  child: Text(
                    "No hay pólizas registradas",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : ListView.builder(
                  itemCount: polizas.length,
                  itemBuilder: (context, index) {
                    final poliza = polizas[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 4,
                      child: ListTile(
                        leading: Icon(Icons.policy, size: 40, color: Colors.blue),
                        title: Text(
                          "Póliza: ${poliza['id']}",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Auto: ${poliza['auto'] ?? 'Desconocido'}"),
                            Text("Costo: \$${poliza['costo'] ?? '0.00'}"),
                            Text("Fecha de Vigencia: ${poliza['fechaVigencia'] ?? 'No disponible'}"),
                            Text("Cliente ID: ${poliza['idCliente'] ?? '-'}"),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.green),
                              onPressed: () => irAEditarPolizaScreen(poliza),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => eliminarPoliza(poliza['id']),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
