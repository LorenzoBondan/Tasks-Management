import 'package:flutter/material.dart';
import 'package:tasks_management/entities/task.dart';
import 'package:tasks_management/services/comment_service.dart';
import 'package:tasks_management/services/task_service.dart';
import 'package:tasks_management/utils/formatters.dart';

class TaskDetailsPage extends StatefulWidget {
  final Task task;
  final VoidCallback onToggleCompletion;

  const TaskDetailsPage({super.key, required this.task, required this.onToggleCompletion});

  @override
  TaskDetailsPageState createState() => TaskDetailsPageState();
}

class TaskDetailsPageState extends State<TaskDetailsPage> {
  late TaskService service = TaskService();
  late CommentService commentService = CommentService();
  late bool isCompleted;

  @override
  void initState() {
    super.initState();
    isCompleted = widget.task.isCompleted;
  }

  void _toggleCompletion() {
    setState(() {
      isCompleted = !isCompleted;
      service.updateIsCompleted(widget.task.id);
    });
    widget.onToggleCompletion();
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

            Row(
              children: [
                Text('Status: ', style: const TextStyle(fontSize: 14)),
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
            
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
