import 'package:flutter/material.dart';
import '../services/api_service.dart';

class EditarClienteScreen extends StatefulWidget {
  final Map<String, dynamic> cliente;

  EditarClienteScreen({required this.cliente});

  @override
  _EditarClienteScreenState createState() => _EditarClienteScreenState();
}

class _EditarClienteScreenState extends State<EditarClienteScreen> {
  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nombreController;
  late TextEditingController apellidoController;
  late TextEditingController dniController;
  late TextEditingController fechaNacimientoController;

  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController(text: widget.cliente['nombre']);
    apellidoController = TextEditingController(text: widget.cliente['apellido']);
    dniController = TextEditingController(text: widget.cliente['dni']);
    fechaNacimientoController = TextEditingController(text: widget.cliente['fechaDeNacimiento']);
  }

  void actualizarCliente() async {
    if (_formKey.currentState!.validate()) {
      final datosActualizados = {
        "nombre": nombreController.text,
        "apellido": apellidoController.text,
        "dni": dniController.text,
        "fechaDeNacimiento": fechaNacimientoController.text,
      };

      await apiService.updateCliente(widget.cliente['id'], datosActualizados);
      
      Navigator.pop(context, {
        "id": widget.cliente['id'],
        ...datosActualizados,
      }); // Devuelve el cliente actualizado a la pantalla anterior
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Editar Cliente")),
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
                onPressed: actualizarCliente,
                child: Text("Actualizar Cliente"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
