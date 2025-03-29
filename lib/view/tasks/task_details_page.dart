import 'package:flutter/material.dart';
import 'package:tasks_management/entities/task.dart';
import 'package:tasks_management/utils/formatters.dart';

class TaskDetailsPage extends StatelessWidget {
  final Task task;

  const TaskDetailsPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('Details: ${task.title}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(task.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(task.description, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 10),
            Text('Priority: ${task.priority.name}', style: const TextStyle(fontSize: 14)),
            
            const SizedBox(height: 20),

            Text('Comments', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: task.comments.length,
                itemBuilder: (context, index) {
                  final item = task.comments[index];
                  return ListTile(
                    title: Text(item.text, style: const TextStyle(fontSize: 14)),
                    subtitle: Text(formatDate(item.moment), style: const TextStyle(fontSize: 12)),
                  );
                },
              ),
            ),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Back'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}