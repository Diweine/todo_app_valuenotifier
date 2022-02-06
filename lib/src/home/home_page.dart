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

  TextEditingController tasktitlecontroller = TextEditingController();
  TextEditingController taskdescriptioncontroller = TextEditingController();

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

    _showAddTaskDialog(BuildContext context) => showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Nova Tarefa"),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          hintText: 'Tarefa',
                        ),
                        controller: tasktitlecontroller,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          hintText: 'Descrição',
                        ),
                        controller: taskdescriptioncontroller,
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                ElevatedButton(
                  child: const Text("Salvar"),
                  onPressed: () {
                    store.add(
                      tasktitlecontroller.text,
                      taskdescriptioncontroller.text,
                    );
                    Navigator.of(context).pop();
                    tasktitlecontroller.text = "";
                    taskdescriptioncontroller.text = "";
                  },
                ),
              ],
            );
          },
        );

    _showUpdateTaskDialog(
      String id,
      String title,
      String description,
      bool status,
    ) =>
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Alteração de Tarefa"),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          hintText: 'Tarefa',
                        ),
                        controller: tasktitlecontroller,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          hintText: 'Descrição',
                        ),
                        controller: taskdescriptioncontroller,
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                ElevatedButton(
                  child: const Text("Salvar"),
                  onPressed: () {
                    store.update(
                      id,
                      tasktitlecontroller.text,
                      taskdescriptioncontroller.text,
                      status,
                    );
                    Navigator.of(context).pop();
                    tasktitlecontroller.text = "";
                    taskdescriptioncontroller.text = "";
                  },
                ),
              ],
            );
          },
        );

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
                      onPressed: () => store.update(
                        task.id,
                        task.title,
                        task.description,
                        !task.status,
                      ),
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
                          onPressed: () {
                            _showUpdateTaskDialog(
                              task.id,
                              task.title,
                              task.description,
                              task.status,
                            );
                            tasktitlecontroller.text = task.title;
                            taskdescriptioncontroller.text = task.description;
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => store.delete(task.id),
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: SizedBox(
              width: 40.0,
              child: ElevatedButton(
                onPressed: store.fechTasks,
                child: Icon(Icons.refresh_sharp, color: Colors.grey[700]),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(5),
                  primary: Colors.white, // <-- Button color
                  onPrimary: Colors.red, // <-- Splash color
                ),
              ),
            ),
          ),
        ],
      ),
      body: child,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => {
          tasktitlecontroller.text = "",
          taskdescriptioncontroller.text = "",
          _showAddTaskDialog(context)
        },
      ),
    );
  }
}
