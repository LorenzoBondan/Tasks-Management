import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasks_management/entities/comment.dart';
import 'package:tasks_management/entities/task.dart';
import 'package:tasks_management/services/comment_service.dart';
import 'package:tasks_management/services/task_service.dart';
import 'package:tasks_management/view/comments/comment_form_page.dart';
import 'package:tasks_management/view/comments/comment_list_page.dart';
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
  late List<Comment> comments;

  @override
  void initState() {
    super.initState();
    isCompleted = widget.task.isCompleted;
    service = Provider.of<TaskService>(context, listen: false);
    commentService = Provider.of<CommentService>(context, listen: false);
    _loadComments();
  }

  void _loadComments() {
    setState(() {
      comments = commentService.findByTaskId(widget.task.id);
    });
  }

  void _deleteComment(int commentId) {
    commentService.delete(commentId);
    _loadComments();
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
      appBar: AppBar(
        title: Text('Task Details', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(widget.task.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
            const SizedBox(height: 10),

            Text(widget.task.description, style: const TextStyle(fontSize: 14, color: Colors.black87)),
            const SizedBox(height: 10),

            Text('Priority: ${widget.task.priority.name}', style: const TextStyle(fontSize: 14, color: Colors.black87)),
            const SizedBox(height: 10),

            Row(
              children: [
                Text('Completed: ', style: const TextStyle(fontSize: 14, color: Colors.black87)),
                Switch(
                  value: isCompleted,
                  onChanged: (value) => _toggleCompletion(),
                  activeColor: Colors.deepPurple,
                ),
              ],
            ),
            const SizedBox(height: 20),

            Text('Comments', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
            CommentListPage(comments: commentService.findByTaskId(widget.task.id), onDelete: _deleteComment, onEdit: _loadComments),
            
            Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                child: const Icon(Icons.add),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CommentFormPage(taskId: widget.task.id)),
                  );
                  _loadComments();
                },
              ),
            ),
            const SizedBox(height: 40),
            
            SizedBox(
              width: double.infinity, 
              child: 
                Center(
                  child: 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                            
                        ElevatedButton.icon(
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            iconColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TaskFormPage(task: widget.task)),
                            );
                          },
                        ),

                        ElevatedButton.icon(
                          icon: const Icon(Icons.delete),
                          label: const Text('Delete'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            iconColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                          onPressed: () {
                            _confirmDelete(context, widget.task.id);
                          },
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Back'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            iconColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                          onPressed: () => Navigator.pop(context),
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