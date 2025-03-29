import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasks_management/entities/priority.dart';
import 'package:tasks_management/entities/task.dart';
import 'package:tasks_management/services/task_service.dart';

class TaskFormPage extends StatefulWidget {
  final Task? task;

  const TaskFormPage({super.key, this.task});

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  late TaskService service;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  Priority? _selectedPriority;

  @override
  void initState() {
    super.initState();
    service = Provider.of<TaskService>(context, listen: false);
    
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _selectedPriority = widget.task!.priority;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.task == null ? 'Add Task' : 'Edit Task')),
      
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Enter a task title' : null,
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) => value!.isEmpty ? 'Enter a task description' : null,
              ),
              const SizedBox(height: 20),

              DropdownButtonFormField<Priority>(
                value: _selectedPriority,
                decoration: const InputDecoration(labelText: 'Priority'),
                items: Priority.values.map((priority) {
                  return DropdownMenuItem<Priority>(
                    value: priority,
                    child: Text(priority.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPriority = value;
                  });
                },
                validator: (value) => value == null ? 'Select a priority' : null,
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final id = widget.task?.id ?? 0;
                    final title = _titleController.text;
                    final description = _descriptionController.text;
                    final priority = _selectedPriority ?? Priority.low;

                    if (widget.task == null) {
                      service.create(Task(id: 0, title: title, description: description, priority: priority, comments: List.empty()));
                    } else {
                      service.update(Task(id: id, title: title, description: description, priority: priority, comments: widget.task!.comments));
                    }

                    Navigator.pop(context);
                  }
                }, 
                child: Text(widget.task == null ? 'Create' : 'Update'),
              ),
            ],
          ),

        ),
      ),
    );
  }
}