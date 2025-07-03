import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'addpageScreen.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  Future<void> fetchTodo() async {
    const url =
        'https://crudcrud.com/api/2a63f04368bc4bd2a5342aab7af52605/todos';
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List;
        setState(() {
          items = json;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        showError("Fetch failed with status: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => isLoading = false);
      showError("Fetch failed: $e");
    }
  }

  void showError(String message) {
    final snackbar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void navigateToAddPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTodoPage()),
    );
    fetchTodo(); // Refresh after adding new todo
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 41, 34, 34),
        title: const Text('Todo list'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : items.isEmpty
              ? const Center(child: Text("No Todos Found"))
              : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index] as Map;
                    final id = item['_id'] as String;
                    return ListTile(
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text(item['title']),
                      subtitle: Text(item['description']),
                      trailing: PopupMenuButton(
                        onSelected: (value) {
                          if (value == 'edit') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddTodoPage(todo: item),
                              ),
                            ).then(
                                (_) => fetchTodo()); // Refresh list after edit
                          } else if (value == 'delete') {
                            deleteById(id);
                          }
                        },
                        itemBuilder: (context) {
                          return [
                            const PopupMenuItem(
                              child: Text('Edit'),
                              value: 'edit',
                            ),
                            const PopupMenuItem(
                              child: Text('Delete'),
                              value: 'delete',
                            ),
                          ];
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        label: const Text("Add Todo"),
      ),
    );
  }

  Future<void> deleteById(String id) async {
    final url =
        'https://crudcrud.com/api/2a63f04368bc4bd2a5342aab7af52605/todos/$id';
    final uri = Uri.parse(url);

    try {
      final response = await http.delete(uri);
      if (response.statusCode == 200 || response.statusCode == 204) {
        // Successfully deleted
        final newItems = items.where((item) => item['_id'] != id).toList();
        setState(() {
          items = newItems;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Todo Deleted")),
        );
      } else {
        showError("Delete failed: ${response.statusCode}");
      }
    } catch (e) {
      showError("Delete failed: $e");
    }
  }
}
