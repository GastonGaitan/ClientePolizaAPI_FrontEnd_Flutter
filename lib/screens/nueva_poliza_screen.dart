import 'package:flutter/material.dart';
import '../services/api_service.dart';

class NuevaPolizaScreen extends StatefulWidget {
  @override
  _NuevaPolizaScreenState createState() => _NuevaPolizaScreenState();
}

class _NuevaPolizaScreenState extends State<NuevaPolizaScreen> {
  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController autoController = TextEditingController();
  final TextEditingController costoController = TextEditingController();
  final TextEditingController fechaVigenciaController = TextEditingController();
  final TextEditingController idClienteController = TextEditingController();

  void agregarPoliza() async {
    if (_formKey.currentState!.validate()) {
      try {
        final nuevaPoliza = await apiService.createPoliza({
          "Auto": autoController.text,
          "Costo": double.parse(costoController.text),
          "FechaVigencia": fechaVigenciaController.text,
          "IdCliente": int.parse(idClienteController.text),
        });

        if (nuevaPoliza != null) {
          Navigator.pop(context, nuevaPoliza);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error al agregar póliza: ${e.toString()}"), // Muestra el mensaje de error
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nueva Póliza")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: autoController,
                decoration: InputDecoration(labelText: "Auto"),
                validator: (value) => value!.isEmpty ? "Ingrese el auto" : null,
              ),
              TextFormField(
                controller: costoController,
                decoration: InputDecoration(labelText: "Costo"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Ingrese el costo" : null,
              ),
              TextFormField(
                controller: fechaVigenciaController,
                decoration: InputDecoration(labelText: "Fecha de Vigencia (YYYY-MM-DD)"),
                validator: (value) => value!.isEmpty ? "Ingrese una fecha válida" : null,
              ),
              TextFormField(
                controller: idClienteController,
                decoration: InputDecoration(labelText: "ID del Cliente"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Ingrese un ID válido" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: agregarPoliza,
                child: Text("Guardar Póliza"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
