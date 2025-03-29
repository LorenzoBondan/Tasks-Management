import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasks_management/services/comment_service.dart';
import 'package:tasks_management/services/task_service.dart';
import 'package:tasks_management/view/tasks/task_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskService()),
        ChangeNotifierProvider(create: (_) => CommentService())
      ],
      child: MaterialApp(
        title: 'Tasks Management',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const TaskListPage(),
      ),
    );
  }
}
