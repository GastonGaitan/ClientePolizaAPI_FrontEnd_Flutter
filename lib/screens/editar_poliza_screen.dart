import 'package:flutter/material.dart';
import '../services/api_service.dart';

class EditarPolizaScreen extends StatefulWidget {
  final Map<String, dynamic> poliza;

  EditarPolizaScreen({required this.poliza});

  @override
  _EditarPolizaScreenState createState() => _EditarPolizaScreenState();
}

class _EditarPolizaScreenState extends State<EditarPolizaScreen> {
  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController autoController;
  late TextEditingController costoController;
  late TextEditingController fechaVigenciaController;
  late TextEditingController idClienteController;

  @override
  void initState() {
    super.initState();
    autoController = TextEditingController(text: widget.poliza['auto']);
    costoController = TextEditingController(text: widget.poliza['costo'].toString());
    fechaVigenciaController = TextEditingController(text: widget.poliza['fechaVigencia']);
    idClienteController = TextEditingController(text: widget.poliza['idCliente'].toString());
  }

  void actualizarPoliza() async {
    if (_formKey.currentState!.validate()) {
      try {
        final polizaActualizada = {
          "Auto": autoController.text,
          "Costo": double.parse(costoController.text),
          "FechaVigencia": fechaVigenciaController.text,
          "IdCliente": int.parse(idClienteController.text),
        };

        await apiService.updatePoliza(widget.poliza['id'], polizaActualizada);

        Navigator.pop(context, {...widget.poliza, ...polizaActualizada});
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al actualizar póliza: ${e.toString()}"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Editar Póliza")),
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
                onPressed: actualizarPoliza,
                child: Text("Guardar Cambios"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
