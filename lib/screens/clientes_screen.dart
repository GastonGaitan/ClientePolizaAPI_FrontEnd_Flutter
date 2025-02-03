import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ClientesScreen extends StatefulWidget {
  @override
  _ClientesScreenState createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  final ApiService apiService = ApiService();
  late Future<List<dynamic>> clientes;

  @override
  void initState() {
    super.initState();
    cargarClientes();
  }

  void cargarClientes() {
    setState(() {
      clientes = apiService.getClientes();
    });
  }

  void eliminarCliente(int id) async {
    try {
      await apiService.deleteCliente(id);
      cargarClientes(); // Recargar lista después de eliminar
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
      body: FutureBuilder<List<dynamic>>(
        future: clientes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final cliente = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  child: ListTile(
                    leading: Icon(Icons.person, size: 40, color: Colors.blue), // Icono de persona
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
                      onPressed: () => eliminarCliente(cliente['id']),
                    ),
                    contentPadding: EdgeInsets.all(16),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
