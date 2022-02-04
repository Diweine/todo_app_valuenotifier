import 'package:flutter/material.dart';
import 'package:todo_app_valuenotifier/src/home/service/task_service.dart';
import 'package:todo_app_valuenotifier/src/home/states/task_state.dart';

class TaskStore extends ValueNotifier<TaskState> {
  final TaskService service;

  TaskStore(this.service) : super(EmptyTaskState());
  Future<void> fechTasks() async {
    value = LoadingTaskState();
    try {
      await Future.delayed(
        const Duration(seconds: 2),
      );
      final tasks = await service.fechTasks();
      value = SuccessTaskState(tasks);
    } catch (e) {
      value = ErrorTaskState(e.toString());
    }
  }
}
