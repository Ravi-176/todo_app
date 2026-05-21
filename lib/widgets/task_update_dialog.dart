import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/providers/task_entry_provider.dart';

class TaskUpdateDialog extends ConsumerStatefulWidget{
  final TodoTask task;
  const TaskUpdateDialog({required this.task,super.key});
  @override
  ConsumerState<TaskUpdateDialog> createState() => _TaskUpdateDialogState();
}
class _TaskUpdateDialogState extends ConsumerState<TaskUpdateDialog>{
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool isLoading = false;
  @override
  void initState(){
    super.initState();
    _titleController = TextEditingController(text:widget.task.title);
    _contentController = TextEditingController(text:widget.task.content);
  }
  @override
  void dispose(){
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
  Future<void> _updateTask() async{
    if(_titleController.text.trim().isEmpty || 
    _contentController.text.trim().isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content:Text('Fields cannot be empty'))
      );
      return;
    }
    try{
       setState((){
      isLoading = true;
    });
    final updatedTask = TodoTask(
      id:widget.task.id,
      title:_titleController.text.trim(),
      content:_contentController.text.trim(),
      date:widget.task.date
    );
    await ref.read(taskServiceProvider).
    updateTaskEntry(widget.task.id, updatedTask);
    if(mounted){
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content:Text('Task updated successfully'))
      );
    }
    }
   catch(e){
    ScaffoldMessenger.of(context).
    showSnackBar(
      SnackBar(content:Text('Error: $e')),
    );
      
   }
   finally{
    if(mounted){
      setState((){
        isLoading = false;
      });
    }
   }
  }
  
  @override
  Widget build(BuildContext context){
     return AlertDialog(

      title: const Text("Update Task"),

      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: "Content",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),

      actions: [

        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),

        ElevatedButton(
          onPressed:isLoading?null:_updateTask,

          child: isLoading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(),       
                  
                )
              : const Text("Update"),
        ),
      ],
    );
  }
}

  
 
