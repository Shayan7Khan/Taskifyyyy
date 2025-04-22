import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double _deviceHeight;

  String? _newTaskAdded;
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
      body: _taskList(),
      floatingActionButton: _addTaskButton(),
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
            onSubmitted: (value) {},
            onChanged: (value) {
              setState(() {
                _newTaskAdded = value;
              });
            },
          ),
        );
      },
    );
  }

  Widget _taskList() {
    return ListView(
      children: [
        ListTile(
          title: Text(
            'This is a Task',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          subtitle: Text(DateTime.now().toString()),
          trailing: Icon(Icons.check_box_outline_blank),
        ),
      ],
    );
  }
}
