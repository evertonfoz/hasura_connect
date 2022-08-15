import 'package:example/app/core/exceptions/failure.dart';
import 'package:example/app/modules/home/states/task_state.dart';
import 'package:example/app/modules/home/stores/task_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, this.title = 'Home Page'}) : super(key: key);
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final TaskStore store = Modular.get();

  @override
  void initState() {
    super.initState();
    store.watchTasks();
  }

  void createTaskDialog() {
    var taskDescription = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Criar nova tarefa"),
          content: TextField(
            onChanged: (value) {
              taskDescription = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                store.createTask(taskDescription);
                Navigator.pop(context);
              },
              child: Text('Criar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              createTaskDialog();
            },
            icon: Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      body: ScopedBuilder<TaskStore, Failure, TaskState>.transition(
        store: store,
        onLoading: (_) => Center(
          child: CircularProgressIndicator(),
        ),
        onError: (context, error) => Center(
          child: Text('Deu Ruim'),
        ),
        onState: (context, state) {
          final listTasks = state.tasks;
          return ListView.builder(
            itemCount: listTasks.length,
            itemBuilder: (context, index) {
              final task = listTasks[index];
              return ListTile(
                title: Text('${task.id} - ${task.title}'),
                trailing: IconButton(
                  onPressed: () {
                    store.deleteTask(task.id);
                  },
                  icon: Icon(
                    Icons.delete,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
