import 'package:flutter/material.dart';

void main() {
  runApp(TodoApp());
}

enum Priority { high, medium, low }

class Todo {
  String title;
  Priority priority;
  bool isCompleted;

  Todo({
    required this.title,
    required this.priority,
    this.isCompleted = false,
  });
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SimpliDo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoScreen(),
    );
  }
}

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<Todo> todos = [];

  TextEditingController _todoController = TextEditingController();
  Priority _selectedPriority = Priority.medium;

  void showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
          actions: [
            ElevatedButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void addTodo() {
    setState(() {
      String todoTitle = _todoController.text.trim();
      if (todoTitle.isEmpty) {
        showErrorDialog(context, 'Task cannot be empty. Please enter a task description.');
        return;
      }
      ;

      if (todoTitle.isNotEmpty) {
        Todo newTodo = Todo(
          title: todoTitle,
          priority: _selectedPriority,
        );
        todos.add(newTodo);
        todos.sort((a, b) {
          if (a.isCompleted != b.isCompleted) {
            return a.isCompleted ? 1 : -1;
          } else {
            return a.priority.index.compareTo(b.priority.index);
          }
        });
        _todoController.clear();
      }
    });
  }

  void toggleTodoStatus(int index) {
    setState(() {
      todos[index].isCompleted = !todos[index].isCompleted;
      todos.sort((a, b) {
        if (a.isCompleted != b.isCompleted) {
          return a.isCompleted ? 1 : -1;
        } else {
          return a.priority.index.compareTo(b.priority.index);
        }
      });
    });
  }

  void deleteTodo(int index) {
    setState(() {
      todos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SimpliDo'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                if (index > 0 &&
                    todos[index].isCompleted != todos[index - 1].isCompleted) {
                  return Column(
                    children: [
                      Divider(),
                      ListTile(
                        title: Text(
                          todos[index].isCompleted
                              ? 'Completed Tasks'
                              : 'Incomplete Tasks',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: GestureDetector(
                          onTap: () {
                            toggleTodoStatus(index);
                          },
                          child: todos[index].isCompleted
                              ? Icon(Icons.check_box, color: Colors.red)
                              : Icon(Icons.check_box_outline_blank),
                        ),
                        title: Text(
                          todos[index].title,
                          style: TextStyle(
                            decoration: todos[index].isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        subtitle: Text(
                          'Priority: ${todos[index].priority.toString().split('.').last}',
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deleteTodo(index);
                          },
                        ),
                      ),
                    ],
                  );
                } else {
                  return ListTile(
                    leading: GestureDetector(
                      onTap: () {
                        toggleTodoStatus(index);
                      },
                      child: todos[index].isCompleted
                          ? Icon(Icons.check_box, color: Colors.red)
                          : Icon(Icons.check_box_outline_blank),
                    ),
                    title: Text(
                      todos[index].title,
                      style: TextStyle(
                        decoration: todos[index].isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Text(
                      'Priority: ${todos[index].priority.toString().split('.').last}',
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        deleteTodo(index);
                      },
                    ),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _todoController,
                    decoration: InputDecoration(
                      labelText: 'Add a to-do',
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                DropdownButton<Priority>(
                  value: _selectedPriority,
                  onChanged: (Priority? value) {
                    setState(() {
                      _selectedPriority = value!;
                    });
                  },
                  items: Priority.values.map((Priority priority) {
                    return DropdownMenuItem<Priority>(
                      value: priority,
                      child: Text(priority.toString().split('.').last),
                    );
                  }).toList(),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: addTodo,
                  child: Text('Add'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
