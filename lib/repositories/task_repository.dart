import 'package:tasks_management/entities/comment.dart';
import 'package:tasks_management/entities/priority.dart';
import 'package:tasks_management/entities/task.dart';

class TaskRepository {
  final List<Task> list = [
    Task(id: 1, title: "Task 1", description: 'Description task 1', priority: Priority.low, isCompleted: false, 
      comments: List.of({
        Comment(id: 1, taskId: 1, text: 'Comment 1', moment: DateTime.now()), 
        Comment(id: 2, taskId: 1, text: 'Comment 2', moment: DateTime.now())
        })
    ),
    Task(id: 2, title: "Task 2", description: 'Description task 2', priority: Priority.normal, isCompleted: false),
    Task(id: 3, title: "Task 3", description: 'Description task 3', priority: Priority.high, isCompleted: true),
    Task(id: 4, title: "Task 4", description: 'Description task 4', priority: Priority.normal, isCompleted: false),
    Task(id: 5, title: "Task 5", description: 'Description task 5', priority: Priority.low, isCompleted: true),
    Task(id: 6, title: "Task 6", description: 'Description task 6', priority: Priority.normal, isCompleted: false),
  ];

  List<Task> get findAll => list;

  Task? findById(int id) {
    return list.firstWhere((obj) => obj.id == id, orElse: () => Task(id: 0, title: '', description: '', priority: Priority.low, isCompleted: false));
  }

  void create(Task obj) {
    final newId = list.isNotEmpty ? list.last.id + 1 : 1;
    list.add(Task(id: newId, title: obj.title, description: obj.description, priority: obj.priority, isCompleted: false));
  }

  void update(Task obj) {
    final index = list.indexWhere((p) => p.id == obj.id);
    if (index != -1) {
      list[index] = obj;
    }
  }

  void updateIsCompleted(int taskId) {
    final index = list.indexWhere((p) => p.id == taskId);
    if (index != -1) {
      list[index].isCompleted = !list[index].isCompleted;
    }
  }

  void updatePriority(int taskId, Priority priority) {
    final index = list.indexWhere((p) => p.id == taskId);
    if (index != -1) {
      list[index].priority = priority;
    }
  }

  void delete(int id) {
    list.removeWhere((p) => p.id == id);
  }
}