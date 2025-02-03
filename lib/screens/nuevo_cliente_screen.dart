import 'package:flutter/material.dart';
import '../services/api_service.dart';

class NuevoClienteScreen extends StatefulWidget {
  @override
  _NuevoClienteScreenState createState() => _NuevoClienteScreenState();
}

class _NuevoClienteScreenState extends State<NuevoClienteScreen> {
  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController dniController = TextEditingController();
  final TextEditingController fechaNacimientoController = TextEditingController();

  void agregarCliente() async {
  if (_formKey.currentState!.validate()) {
    try {
      final nuevoCliente = await apiService.createCliente({
        "nombre": nombreController.text,
        "apellido": apellidoController.text,
        "dni": dniController.text,
        "fechaDeNacimiento": fechaNacimientoController.text,
      });

      if (nuevoCliente != null) {
        Navigator.pop(context, nuevoCliente);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()), // Muestra el mensaje de error de la API
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nuevo Cliente")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nombreController,
                decoration: InputDecoration(labelText: "Nombre"),
                validator: (value) => value!.isEmpty ? "Ingrese un nombre" : null,
              ),
              TextFormField(
                controller: apellidoController,
                decoration: InputDecoration(labelText: "Apellido"),
                validator: (value) => value!.isEmpty ? "Ingrese un apellido" : null,
              ),
              TextFormField(
                controller: dniController,
                decoration: InputDecoration(labelText: "DNI"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Ingrese un DNI" : null,
              ),
              TextFormField(
                controller: fechaNacimientoController,
                decoration: InputDecoration(labelText: "Fecha de Nacimiento (YYYY-MM-DD)"),
                validator: (value) => value!.isEmpty ? "Ingrese una fecha válida" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: agregarCliente,
                child: Text("Guardar Cliente"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
