import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://localhost:5276/api"; // URL base de la API

  // Obtener todos los clientes
  Future<List<dynamic>> getClientes() async {
    final response = await http.get(Uri.parse('$baseUrl/Cliente'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error al obtener clientes");
    }
  }

  // Obtener un cliente por ID
  Future<Map<String, dynamic>> getClienteById(int id) async {
      final response = await http.get(Uri.parse('$baseUrl/Cliente/$id'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Error al obtener el cliente");
      }
    }

    // Crear un cliente
    Future<dynamic> createCliente(Map<String, dynamic> clienteData) async {
      final response = await http.post(
        Uri.parse('$baseUrl/Cliente'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(clienteData),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body); // Cliente creado exitosamente
      } else {
        throw response.body; // Lanza el mensaje de error como texto
      }
    }




  // Actualizar un cliente
  Future<void> updateCliente(int id, Map<String, dynamic> data) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/Cliente/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode != 200) {
      throw Exception("Error al actualizar cliente");
    }
  }

  // Eliminar un cliente
  Future<void> deleteCliente(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/Cliente/$id'));
    if (response.statusCode != 200) {
      throw Exception("Error al eliminar cliente");
    }
  }

  // Obtener todas las pólizas
  Future<List<dynamic>> getPolizas() async {
    final response = await http.get(Uri.parse('$baseUrl/Poliza'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error al obtener pólizas");
    }
  }

  // Crear una póliza
  Future<dynamic> createPoliza(Map<String, dynamic> polizaData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Poliza'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(polizaData),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body); // Póliza creada exitosamente
    } else {
      throw response.body; // Lanza el mensaje de error como texto
    }
  }

  // Actualizar una póliza
  Future<void> updatePoliza(int id, Map<String, dynamic> polizaData) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/Poliza/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(polizaData),
    );

    if (response.statusCode != 200) {
      throw Exception("Error al actualizar póliza");
    }
  }

  // Eliminar una póliza
  Future<void> deletePoliza(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/Poliza/$id'));
    if (response.statusCode != 200) {
      throw Exception("Error al eliminar póliza");
    }
  }
}

