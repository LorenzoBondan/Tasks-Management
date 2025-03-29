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
      appBar: AppBar(
        title: Text(widget.comment == null ? 'Add Comment' : 'Edit Comment'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

              TextFormField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: 'Text',
                  labelStyle: TextStyle(color: Colors.deepPurple),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Enter a Comment text' : null,
              ),
              const SizedBox(height: 25),

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
                
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: Text(widget.comment == null ? 'Create' : 'Update')
              ),
            ],
          ),
        ),
      ),
    );
  }
}
