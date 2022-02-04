import 'package:todo_app_valuenotifier/src/home/models/task_model.dart';

abstract class TaskState {
  const TaskState();
}

class EmptyTaskState extends TaskState {}

class LoadingTaskState extends TaskState {}

class ErrorTaskState extends TaskState {
  final String message;

  const ErrorTaskState(this.message);
}

class SuccessTaskState extends TaskState {
  final List<TaskModel> tasks;

  const SuccessTaskState(this.tasks);
}
