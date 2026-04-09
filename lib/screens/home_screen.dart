import 'package:flutter/material.dart';
import '../models/todo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Todo> todos = [];

  final TextEditingController controller = TextEditingController();

  void addTodo() {
    if (controller.text.isEmpty) return;

    setState(() {
      todos.add(Todo(title: controller.text));
    });

    controller.clear();
  }

  void deleteTodo(int index) {
    setState(() {
      todos.removeAt(index);
    });
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
                  leading: Checkbox(
                    value: todos[index].isDone,
                    onChanged: (value) {
                      setState(() {
                        todos[index].isDone = value!;
                      });
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