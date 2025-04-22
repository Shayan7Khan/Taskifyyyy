import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task/models/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double _deviceHeight;

  String? _newTaskAdded;
  Box? box;
  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    print('New Task Added: $_newTaskAdded');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Taskifyyy!',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        ),
        toolbarHeight: _deviceHeight * 0.15,
        backgroundColor: Color.fromRGBO(231, 76, 60, 1),
      ),
      body: _taskView(),
      floatingActionButton: _addTaskButton(),
    );
  }

  Widget _taskView() {
    return FutureBuilder(
      future: Hive.openBox('tasks'),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          box = snapshot.data;
          return _taskList();
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _addTaskButton() {
    return FloatingActionButton(
      onPressed: () {
        return _displayTaskPop();
      },
      backgroundColor: Color.fromRGBO(231, 76, 60, 1),
      child: Icon(Icons.add),
    );
  }

  _displayTaskPop() {
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Add New Task!'),

          content: TextField(
            onSubmitted: (value) {
              if (_newTaskAdded != null) {
                var task = Task(
                  content: _newTaskAdded!,
                  time: DateTime.now(),
                  done: false,
                );
                box!.add(task.toMap());
                setState(() {
                  _newTaskAdded = null;
                  Navigator.pop(context);
                });
              }
            },
            onChanged: (value) {
              setState(() {
                _newTaskAdded = value;
              });
            },
          ),
          actions: [
            Row(
              children: [ElevatedButton(onPressed: () {}, child: Text('Yes'))],
            ),
          ],
        );
      },
    );
  }

  Widget _taskList() {
    List tasks = box!.values.toList();
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, int index) {
        var task = Task.fromMap(tasks[index]);
        return ListTile(
          title: Text(
            task.content,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              decoration: task.done ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Text(task.time.toString()),
          trailing:
              task.done
                  ? Icon(Icons.check_box_outlined, color: Colors.red)
                  : Icon(
                    Icons.check_box_outline_blank_outlined,
                    color: Colors.red,
                  ),
          onTap: () {
            task.done = !task.done;
            box!.putAt(index, task.toMap());
            setState(() {});
          },
          onLongPress: () {
            box!.deleteAt(index);
            setState(() {});
          },
        );
      },
    );
  }
}
