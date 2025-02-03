import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'nueva_poliza_screen.dart';

class PolizasScreen extends StatefulWidget {
  @override
  _PolizasScreenState createState() => _PolizasScreenState();
}

class _PolizasScreenState extends State<PolizasScreen> {
  final ApiService apiService = ApiService();
  List<dynamic> polizas = [];
  bool isLoading = true; // Nuevo estado para manejar la carga

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
        isLoading = false; // Carga completada
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Carga fallida
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al obtener las pólizas")),
      );
    }
  }

  void eliminarPoliza(int id) async {
    try {
      await apiService.deletePoliza(id);
      setState(() {
        polizas.removeWhere((poliza) => poliza['id'] == id); // ✅ Usa el ID de la póliza correctamente
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Póliza eliminada correctamente"), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al eliminar la póliza"), backgroundColor: Colors.red),
      );
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pólizas"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: irANuevaPolizaScreen,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Solo se muestra mientras carga
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
                          "Poliza: ${poliza['id']}",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Auto: ${poliza['auto'] ?? 'Desconocido'}"), // ✅ "auto" en minúscula
                            Text("Costo: \$${poliza['costo'] ?? '0.00'}"),
                            Text("Fecha de Vigencia: ${poliza['fechaVigencia'] ?? 'No disponible'}"),
                            Text("Cliente ID: ${poliza['idCliente'] ?? '-'}"),

                          ],
                        ),
                        trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () { 
                          eliminarPoliza(poliza['id']);
                          setState(() {
                              polizas.remove(poliza);
                            });
                        }, 

                      ),

                      ),
                    );
                  },
                ),
    );
  }
}
