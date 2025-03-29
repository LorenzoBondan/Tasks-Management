import 'package:tasks_management/entities/comment.dart';

class CommentRepository {
  final List<Comment> list = [
    Comment(id: 1, taskId: 1, text: "Comment 1", moment: DateTime.now()),
    Comment(id: 2, taskId: 1, text: "Comment 2", moment: DateTime.now()),
  ];

  List<Comment> get findAll => list;

  List<Comment> findByTaskId(int taskId) {
    return list.where((obj) => obj.taskId == taskId).toList();
  }

  Comment? findById(int id) {
    return list.firstWhere((obj) => obj.id == id, orElse: () => Comment(id: 0, taskId: 0, text: '', moment: DateTime.now()));
  }

  void create(Comment obj) {
    final newId = list.isNotEmpty ? list.last.id + 1 : 1;
    list.add(Comment(id: newId, taskId: obj.taskId, text: obj.text, moment: DateTime.now()));
  }

  void update(Comment obj) {
    final index = list.indexWhere((p) => p.id == obj.id);
    if (index != -1) {
      list[index] = obj;
    }
  }

  void delete(int id) {
    list.removeWhere((p) => p.id == id);
  }
}