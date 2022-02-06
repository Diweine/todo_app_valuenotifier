import 'dart:convert';
import 'package:http/http.dart';
import 'package:todo_app_valuenotifier/src/home/models/task_model.dart';

class TaskService {
  final Client client;
  final url = 'http://localhost:3031/tasks';

  TaskService(this.client);

  Uri _returnUri(String url) {
    final uri = Uri.parse(url);
    return uri;
  }

  Future<List<TaskModel>> fechTasks() async {
    final response = await client.get(_returnUri(url));

    if (response.statusCode != 200) {
      throw Exception('Erro');
    }

    final data = jsonDecode(response.body) as List;

    final tasks = data.map((e) => TaskModel.fromMap(e)).toList();

    return tasks;
  }

  Future<bool> delete(String id) async {
    final response = await client.delete(_returnUri(url + "/" + id.toString()));

    if (response.statusCode != 200) {
      throw Exception('Erro');
    } else {
      return true;
    }
  }

  Future<bool> add(TaskModel task) async {
    final response = await client.post(
      _returnUri(url),
      body: jsonEncode(task.toMap()),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode != 200) {
      throw Exception('Erro');
    } else {
      return true;
    }
  }

  Future<bool> update(TaskModel task) async {
    final response = await client.put(
      _returnUri(url + "/" + task.id.toString()),
      body: jsonEncode(task.toMap()),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode != 200) {
      throw Exception('Erro');
    } else {
      return true;
    }
  }

  Future<bool> updateStatus(TaskModel task) async {
    final response = await client.put(
      _returnUri(url + "/" + task.id.toString()),
      body: jsonEncode(task.toMap()),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode != 200) {
      throw Exception('Erro');
    } else {
      return true;
    }
  }
}
