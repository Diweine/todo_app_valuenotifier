import 'package:flutter/material.dart';
import 'package:todo_app_valuenotifier/src/home/models/task_model.dart';
import 'package:todo_app_valuenotifier/src/home/service/task_service.dart';
import 'package:todo_app_valuenotifier/src/home/states/task_state.dart';

class TaskStore extends ValueNotifier<TaskState> {
  final TaskService service;

  TaskStore(this.service) : super(EmptyTaskState());

  Future<void> fechTasks() async {
    value = LoadingTaskState();

    try {
      /*await Future.delayed(
        const Duration(seconds: 1),
      );*/
      final tasks = await service.fechTasks();
      value = SuccessTaskState(tasks);
    } catch (e) {
      value = ErrorTaskState(e.toString());
    }
  }

  Future<void> add(String title, String description) async {
    value = LoadingTaskState();
    const bool status = false;

    TaskModel task = TaskModel.fromMap({
      "id": "0",
      "title": title,
      "description": description,
      "status": status,
    });

    final success = await service.add(task);

    if (success) {
      fechTasks();
    } else {
      value = const ErrorTaskState('Tarefa não foi adicionada');
    }
  }

  Future<void> delete(String id) async {
    value = LoadingTaskState();

    final success = await service.delete(id);

    if (success) {
      fechTasks();
    } else {
      value = const ErrorTaskState('Tarefa não deletada');
    }
  }

  Future<void> update(
      String id, String title, String description, bool status) async {
    value = LoadingTaskState();

    TaskModel task = TaskModel.fromMap({
      "id": id,
      "title": title,
      "description": description,
      "status": status,
    });

    final success = await service.update(task);

    if (success) {
      fechTasks();
    } else {
      value = const ErrorTaskState('A Tarefa não foi atualizada');
    }
  }
}
