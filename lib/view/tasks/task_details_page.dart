import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasks_management/entities/task.dart';
import 'package:tasks_management/services/comment_service.dart';
import 'package:tasks_management/services/task_service.dart';
import 'package:tasks_management/utils/formatters.dart';
import 'package:tasks_management/view/tasks/task_form_page.dart';
import 'package:tasks_management/view/tasks/task_list_page.dart';

class TaskDetailsPage extends StatefulWidget {
  final Task task;
  final VoidCallback onToggleCompletion;

  const TaskDetailsPage({super.key, required this.task, required this.onToggleCompletion});

  @override
  TaskDetailsPageState createState() => TaskDetailsPageState();
}

class TaskDetailsPageState extends State<TaskDetailsPage> {
  late TaskService service;
  late CommentService commentService;
  late bool isCompleted;

  @override
  void initState() {
    super.initState();
    isCompleted = widget.task.isCompleted;
    service = TaskService();
    commentService = CommentService();
  }

  void _toggleCompletion() {
    setState(() {
      isCompleted = !isCompleted;
    });

    final taskService = Provider.of<TaskService>(context, listen: false);
    taskService.updateIsCompleted(widget.task.id);

    widget.onToggleCompletion();
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => TaskListPage()),
                );
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
    return Scaffold(
      appBar: AppBar(title: Text('Details: ${widget.task.title}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(widget.task.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            Text(widget.task.description, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 10),

            Text('Priority: ${widget.task.priority.name}', style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 10),

            Row(
              children: [
                Text('Completed: ', style: const TextStyle(fontSize: 14)),
                Switch(
                  value: isCompleted,
                  onChanged: (value) => _toggleCompletion(),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Text('Comments', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: widget.task.comments.length,
                itemBuilder: (context, index) {
                  final item = widget.task.comments[index];
                  return ListTile(
                    title: Text(item.text, style: const TextStyle(fontSize: 14)),
                    subtitle: Text(formatDate(item.moment), style: const TextStyle(fontSize: 12)),
                  );
                },
              ),
            ),
            
            SizedBox(
              width: double.infinity, 
              child: 
                Center(
                  child: 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                            
                        ElevatedButton(
                          child: const Text('Edit'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TaskFormPage(task: widget.task)),
                            );
                          },
                        ),
                        ElevatedButton(
                          child: const Text('Delete'),
                          onPressed: () {
                            _confirmDelete(context, widget.task.id);
                          },
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Back'),
                        ),

                    ],
                  ),
                )
              ),
          ],
        ),
      ),
    );
  }
}
