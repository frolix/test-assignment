import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task_model.dart';

class ApiRepository {
  final String url;

  ApiRepository(this.url);

  // Метод для отримання завдань
  Future<List<TaskModel>> fetchTasks() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      if (!jsonBody['error']) {
        final List<dynamic> tasks = jsonBody['data'];
        return tasks.map((task) => TaskModel.fromJson(task)).toList();
      } else {
        throw Exception('API Error: ${jsonBody['message']}');
      }
    } else {
      throw Exception('HTTP Error: ${response.statusCode}');
    }
  }

  // Метод для відправки результатів
  Future<Map<String, dynamic>> sendResults(
      List<Map<String, dynamic>> results) async {
    final formattedResults = results.map((e) {
      return {
        "id": e["id"],
        "result": e["result"],
      };
    }).toList();

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(formattedResults),
    );

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      if (!jsonBody['error']) {
        return jsonBody;
      } else {
        throw Exception('API Error: ${jsonBody['message']}');
      }
    } else {
      throw Exception('HTTP Error: ${response.statusCode}');
    }
  }
}
