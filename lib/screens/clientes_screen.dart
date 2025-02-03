import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'nuevo_cliente_screen.dart';
import 'editar_cliente_screen.dart'; // Nueva pantalla para editar cliente

class ClientesScreen extends StatefulWidget {
  @override
  _ClientesScreenState createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  final ApiService apiService = ApiService();
  
  List<dynamic> clientes = [];

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
    await apiService.deleteCliente(id);
    setState(() {
      clientes.removeWhere((cliente) => cliente['id'] == id);
    });
  }

  void irANuevoClienteScreen() async {
    final nuevoCliente = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NuevoClienteScreen()),
    );

    if (nuevoCliente != null) {
      setState(() {
        clientes.add(nuevoCliente);
        
      });
    }
  }

  void irAEditarClienteScreen(Map<String, dynamic> cliente) async {
    final clienteActualizado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarClienteScreen(cliente: cliente),
      ),
    );

    if (clienteActualizado != null) {
      setState(() {
        int index = clientes.indexWhere((c) => c['id'] == clienteActualizado['id']);
        if (index != -1) {
          clientes[index] = clienteActualizado; // Actualiza la lista con los nuevos datos
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Clientes"),
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
              onPressed: irANuevoClienteScreen,
            ),
          ),
        ],
      ),
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.green),
                          onPressed: () => irAEditarClienteScreen(cliente),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            eliminarCliente(cliente['id']);
                            setState(() {
                              clientes.remove(cliente);
                            });
                          },
                          
                        ),
                      ],
                    ),
                    contentPadding: EdgeInsets.all(16),
                  ),
                );
              },
            ),
    );
  }
}
