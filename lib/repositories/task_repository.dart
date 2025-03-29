import 'package:tasks_management/entities/priority.dart';
import 'package:tasks_management/entities/task.dart';

class TaskRepository {
  final List<Task> list = [
    Task(id: 1, title: "Task 1", description: 'Description task 1', priority: Priority.low, isCompleted: false),
    Task(id: 2, title: "Task 2", description: 'Description task 2', priority: Priority.normal, isCompleted: false),
    Task(id: 3, title: "Task 3", description: 'Description task 3', priority: Priority.high, isCompleted: false),
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