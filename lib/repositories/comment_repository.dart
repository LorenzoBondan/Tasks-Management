import 'package:tasks_management/entities/comment.dart';

class CommentRepository {
  final List<Comment> list = [
    Comment(id: 1, text: "Comment 1", moment: DateTime.now()),
    Comment(id: 2, text: "Comment 2", moment: DateTime.now()),
  ];

  List<Comment> get findAll => list;

  Comment? findById(int id) {
    return list.firstWhere((obj) => obj.id == id, orElse: () => Comment(id: 0, text: '', moment: DateTime.now()));
  }

  void create(Comment obj) {
    final newId = list.isNotEmpty ? list.last.id + 1 : 1;
    list.add(Comment(id: newId, text: obj.text, moment: DateTime.now()));
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