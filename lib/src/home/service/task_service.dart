import 'dart:convert';
import 'package:http/http.dart';
import 'package:todo_app_valuenotifier/src/home/models/task_model.dart';

class TaskService {
  final Client client;

  TaskService(this.client);

  Future<List<TaskModel>> fechTasks() async {
    final uri = Uri.parse('http://localhost:3031/tasks');
    final response = await client.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Erro');
    }

    final data = jsonDecode(response.body) as List;

    final tasks = data.map((e) => TaskModel.fromMap(e)).toList();

    return tasks;
  }
}
