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
  Future<void> createCliente(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Cliente'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode != 201) {
      throw Exception("Error al crear cliente");
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
}
