import 'package:flutter/material.dart';
import '../models/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Todo> todos = [];

  final TextEditingController controller = TextEditingController();
  Future<void> saveTodos() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> todoList =
    todos.map((todo) => jsonEncode({
      'title': todo.title,
      'isDone': todo.isDone,
    })).toList();

    await prefs.setStringList('todos', todoList);
  }
  Future<void> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();

    List<String>? todoList = prefs.getStringList('todos');

    if (todoList != null) {
      setState(() {
        todos = todoList.map((item) {
          final data = jsonDecode(item);
          return Todo(
            title: data['title'],
            isDone: data['isDone'],
          );
        }).toList();
      });
    }
  }
  @override
  void initState() {
    super.initState();
    loadTodos();
  }

  void addTodo() {
    if (controller.text.isEmpty) return;

    setState(() {
      todos.add(Todo(title: controller.text));
    });
    saveTodos();

    controller.clear();
  }

  void deleteTodo(int index) {
    setState(() {
      todos.removeAt(index);
    });
    saveTodos();
  }

  void editTodo(int index) {
    TextEditingController editController =
    TextEditingController(text: todos[index].title);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Task"),
          content: TextField(
            controller: editController,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  todos[index].title = editController.text;
                });

                saveTodos(); // ✅ MUST
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Todo App")),
      body: Column(
        children: [

          // 🔤 Input
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Enter task...",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: addTodo,
                ),
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // 📋 List
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    editTodo(index);
                  },
                  leading: Checkbox(
                    value: todos[index].isDone,
                    onChanged: (value) {
                      setState(() {
                        todos[index].isDone = value!;
                      });
                      saveTodos();
                    },
                  ),

                  title: Text(
                    todos[index].title,
                    style: TextStyle(
                      decoration: todos[index].isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),

                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteTodo(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}