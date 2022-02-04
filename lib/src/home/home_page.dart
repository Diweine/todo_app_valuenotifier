import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:todo_app_valuenotifier/src/home/service/task_service.dart';
import 'package:todo_app_valuenotifier/src/home/states/task_state.dart';
import 'package:todo_app_valuenotifier/src/home/store/task_store.dart';
import 'package:todo_app_valuenotifier/src/shared/constants/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final store = TaskStore(TaskService(Client()));

  @override
  void initState() {
    super.initState();
    store.addListener(() {
      setState(() {});
    });

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      store.fechTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Container();

    final state = store.value;

    if (state is EmptyTaskState) {
      child = const Center(
        child: Text('Não há produtos na lista'),
      );
    }
    if (state is LoadingTaskState) {
      child = const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (state is ErrorTaskState) {
      child = Center(
        child: Text(state.message),
      );
    }

    if (state is SuccessTaskState) {
      child = ListView.builder(
          itemCount: state.tasks.length,
          itemBuilder: (_, index) {
            final task = state.tasks[index];
            return Card(
              color: Colors.grey[300],
              margin: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
              child: ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: IconButton(
                      icon: Icon(
                          task.status == true
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: AppColors.azul),
                      onPressed: () => {},
                    ),
                  ),
                  title: Text(task.title),
                  subtitle: Text(task.description),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => {},
                        ),
                      ],
                    ),
                  )),
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Lista de Tarefas')),
      ),
      body: child,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => {},
      ),
    );
  }
}
