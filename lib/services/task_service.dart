import 'package:flutter/material.dart';
import 'package:tasks_management/entities/priority.dart';
import 'package:tasks_management/entities/task.dart';
import 'package:tasks_management/repositories/task_repository.dart';

class TaskService extends ChangeNotifier {
  final TaskRepository repository = TaskRepository();

  List<Task> get findAll => repository.findAll; 

  Task? findById(int id) {
    return repository.findById(id);
  }

  void create(Task obj) {
    repository.create(obj);
    notifyListeners();
  }

  void update(Task obj) {
    repository.update(obj);
    notifyListeners();
  }

  void updateIsCompleted(int taskId) {
    repository.updateIsCompleted(taskId);
    notifyListeners();
  }

  void updatePriority(int taskId, Priority priority) {
    repository.updatePriority(taskId, priority);
    notifyListeners();
  }

  void delete(int id) {
    repository.delete(id);
    notifyListeners();
  }
}