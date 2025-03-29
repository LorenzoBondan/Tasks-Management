import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasks_management/entities/comment.dart';
import 'package:tasks_management/services/comment_service.dart';

class CommentFormPage extends StatefulWidget {
  final Comment? comment;
  final int? taskId;

  const CommentFormPage({super.key, this.comment, this.taskId});

  @override
  State<CommentFormPage> createState() => _CommentFormPageState();
}

class _CommentFormPageState extends State<CommentFormPage> {
  late CommentService service;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    service = Provider.of<CommentService>(context, listen: false);
    
    if (widget.comment != null) {
      _textController.text = widget.comment!.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.comment == null ? 'Add Comment' : 'Edit Comment')),
      
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              
              TextFormField(
                controller: _textController,
                decoration: const InputDecoration(labelText: 'Text'),
                validator: (value) => value!.isEmpty ? 'Enter a Comment text' : null,
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final id = widget.comment?.id ?? 0;
                    final text = _textController.text;

                    if (widget.comment == null) {
                      service.create(Comment(id: 0, taskId: widget.taskId!, text: text, moment: DateTime.now()));
                    } else {
                      service.update(Comment(id: id, taskId: widget.taskId!, text: text, moment: widget.comment!.moment));
                    }

                    Navigator.pop(context);
                  }
                }, 
                child: Text(widget.comment == null ? 'Create' : 'Update'),
              ),
            ],
          ),

        ),
      ),
    );
  }
}