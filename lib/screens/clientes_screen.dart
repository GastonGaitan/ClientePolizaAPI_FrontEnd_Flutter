import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ClientesScreen extends StatefulWidget {
  @override
  _ClientesScreenState createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  final ApiService apiService = ApiService();
  List<dynamic> clientes = []; // Cambiado de Future a List

  @override
  void initState() {
    super.initState();
    cargarClientes();
  }

  void cargarClientes() async {
    final datos = await apiService.getClientes();
    setState(() {
      clientes = datos;
    });
  }

  void eliminarCliente(int id) async {
    try {
      await apiService.deleteCliente(id);
      setState(() {
        clientes.removeWhere((cliente) => cliente['id'] == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Cliente eliminado correctamente")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al eliminar cliente: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Clientes")),
      body: clientes.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: clientes.length,
              itemBuilder: (context, index) {
                final cliente = clientes[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  child: ListTile(
                    leading: Icon(Icons.person, size: 40, color: Colors.blue),
                    title: Text(
                      "${cliente['nombre']} ${cliente['apellido']}",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("ID: ${cliente['id']}"),
                        Text("DNI: ${cliente['dni']}"),
                        Text("Fecha de Nacimiento: ${cliente['fechaDeNacimiento']}"),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                          eliminarCliente(cliente['id']);
                          setState(() {
                            clientes.remove(cliente);
                          });
                      } ,
                    ),
                    contentPadding: EdgeInsets.all(16),
                  ),
                );
              },
            ),
    );
  }
}
