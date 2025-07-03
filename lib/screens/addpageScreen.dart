// ✅ Updated AddTodoPage with support for edit
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({super.key, this.todo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final String baseUrl =
      'https://crudcrud.com/api/2a63f04368bc4bd2a5342aab7af52605/todos';

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      titleController.text = todo['title'];
      descriptionController.text = todo['description'];
    }
  }

  Future<void> submitData() async {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();

    if (title.isEmpty || description.isEmpty) {
      showErrorMessage("Please fill in all fields");
      return;
    }

    final body = {"title": title, "description": description};

    final isEditing = widget.todo != null;
    final uri = isEditing
        ? Uri.parse("$baseUrl/${widget.todo!['_id']}")
        : Uri.parse(baseUrl);

    final response = isEditing
        ? await http.put(uri,
            body: jsonEncode(body),
            headers: {'Content-Type': 'application/json'})
        : await http.post(uri,
            body: jsonEncode(body),
            headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200 || response.statusCode == 201) {
      titleController.clear();
      descriptionController.clear();
      showSuccessMessage(isEditing ? 'Todo Updated' : 'Todo Created');
      Navigator.pop(context);
    } else {
      showErrorMessage('${isEditing ? 'Update' : 'Creation'} Failed');
    }
  }

  void showSuccessMessage(String message) {
    final snackbar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void showErrorMessage(String message) {
    final snackbar = SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.todo != null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 41, 34, 34),
        title: Text(isEditing ? 'Edit Todo' : 'Add Todo'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: "Title"),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: "Description"),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: submitData,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
            ),
            child: Text(isEditing ? 'Update' : 'Submit'),
          ),
        ],
      ),
    );
  }
}
