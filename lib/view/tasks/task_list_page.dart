import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasks_management/services/task_service.dart';
import 'package:tasks_management/view/tasks/task_details_page.dart';
import 'package:tasks_management/view/tasks/task_form_page.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  void _refreshTasks() {
    setState(() {});
  }

  void _confirmDelete(BuildContext context, int taskId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to delete this Task?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Provider.of<TaskService>(context, listen: false).delete(taskId);
                Navigator.pop(dialogContext);
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<TaskService>(context);
    final filteredTasks = service.findAll
        .where((task) => task.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),

            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Task',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),

          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final item = filteredTasks[index];
                return ListTile(
                  title: Text(item.title),
                  subtitle: Text(item.description),
                  leading: GestureDetector(
                    onTap: () {
                      final taskService = Provider.of<TaskService>(context, listen: false);
                      taskService.updateIsCompleted(item.id); 
                      setState(() {}); 
                    },
                    child: Icon(
                      item.isCompleted ? Icons.check_circle : Icons.cancel,
                      color: item.isCompleted ? Colors.green : Colors.red,
                    ),
                  ),
                  // add priority

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      IconButton(
                        icon: const Icon(Icons.visibility, color: Colors.green),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskDetailsPage(task: item, onToggleCompletion: _refreshTasks),
                            ),
                          );
                        },
                      ),

                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TaskFormPage(task: item)),
                          );
                        },
                      ),

                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDelete(context, item.id),
                      ),

                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TaskFormPage()),
          );
        },
      ),
    );
  }
}
