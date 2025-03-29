import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasks_management/services/task_service.dart';
import 'package:tasks_management/view/tasks/task_details_page.dart';
import 'package:tasks_management/view/tasks/task_form_page.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedPriority;
  String? _selectedIsCompleted;

  void _refreshTasks() {
    setState(() {});
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
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _selectedPriority = null;
      _selectedIsCompleted = null;
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<TaskService>(context);
    
    final filteredTasks = service.findAll
      .where((task) {
        bool matchesSearchQuery = task.title.toLowerCase().contains(_searchQuery.toLowerCase());

        bool matchesPriority = _selectedPriority == null || task.priority.name.toLowerCase() == _selectedPriority.toString().toLowerCase();

        bool matchesIsCompleted = _selectedIsCompleted == null || task.isCompleted.toString().toLowerCase() == _selectedIsCompleted.toString().toLowerCase();

        return matchesSearchQuery && matchesPriority && matchesIsCompleted;
      })
      .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks Management', style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 255, 255))),
        backgroundColor: Colors.deepPurple,
        elevation: 5,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Task',
                labelStyle: TextStyle(color: Colors.deepPurple),
                prefixIcon: const Icon(Icons.search, color: Colors.deepPurple),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple)),
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.deepPurple.withValues(alpha: 0.6)),
              ),

              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.deepPurple, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: DropdownButton<String>(
                  hint: const Text("Select Priority", style: TextStyle(color: Colors.deepPurple)),
                  value: _selectedPriority,
                  isExpanded: true, 
                  items: [
                    'Low',
                    'Normal',
                    'High',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: Colors.deepPurple)),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedPriority = newValue;
                    });
                  },
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.deepPurple, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: DropdownButton<String>(
                  hint: const Text("Select Is Completed", style: TextStyle(color: Colors.deepPurple)),
                  value: _selectedIsCompleted,
                  isExpanded: true, 
                  items: [
                    'True', 'False',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: Colors.deepPurple)),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedIsCompleted = newValue;
                    });
                  },
                ),
              ),
            ),
          ),
          
          ElevatedButton(
              onPressed: _clearFilters,
              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 173, 146, 216), foregroundColor: Colors.white),
              child: const Text("Clear Filters"),
            ),
          const SizedBox(height: 12),

          Expanded(
            child: ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final item = filteredTasks[index];
                Color priorityColor;

                switch (item.priority.name) {
                  case 'low':
                    priorityColor = const Color.fromARGB(255, 198, 179, 230);
                    break;
                  case 'normal':
                    priorityColor = const Color.fromARGB(255, 129, 83, 209);
                    break;
                  case 'high':
                    priorityColor = const Color.fromARGB(255, 77, 19, 176);
                    break;
                  default:
                    priorityColor = Colors.grey;
                }

                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: priorityColor,
                        width: 8,
                      ),
                    ),
                  ),
                  child: ListTile(
                    title: Text(item.title),
                    subtitle: Text(item.description),
                    leading: GestureDetector(
                      onTap: () {
                        final taskService = Provider.of<TaskService>(context, listen: false);
                        taskService.updateIsCompleted(item.id);
                        setState(() {});
                      },
                      child: Icon(
                        item.isCompleted ? Icons.check_circle : Icons.cancel,
                        color: item.isCompleted ? Colors.deepPurple : const Color.fromARGB(255, 151, 131, 187),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.visibility, color: Color.fromARGB(255, 100, 100, 100)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskDetailsPage(
                                  task: item,
                                  onToggleCompletion: _refreshTasks,
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Color.fromARGB(255, 100, 100, 100)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TaskFormPage(task: item)),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Color.fromARGB(255, 100, 100, 100)),
                          onPressed: () => _confirmDelete(context, item.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TaskFormPage()),
          );
        },
      ),
    );
  }
}
