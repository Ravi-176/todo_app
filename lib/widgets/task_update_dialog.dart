import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/providers/task_entry_provider.dart';
import 'package:todo_app/services/notification_service.dart';

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
  DateTime? _selectedReminderTime;
  @override
  void initState(){
    super.initState();
    _titleController = TextEditingController(text:widget.task.title);
    _contentController = TextEditingController(text:widget.task.content);
    _selectedReminderTime = widget.task.reminderTime;
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
    int? notificationId = widget.task.notificationId;
    if(_selectedReminderTime != widget.task.reminderTime){
      //cancel old notification
      if(widget.task.notificationId!=null){
        await NotificationService().notifications.cancel(id: widget.task.notificationId!);
      }
      //schedule new notification
      if(_selectedReminderTime!=null){
        notificationId = DateTime.now().millisecondsSinceEpoch.remainder(100000);
        await NotificationService().scheduleNotification(
          id: notificationId, 
          title: _titleController.text.trim(),
          body: _contentController.text.trim(), 
          scheduledTime: _selectedReminderTime!
         );
      }
    }
    final updatedTask = TodoTask(
      id:widget.task.id,
      title:_titleController.text.trim(),
      content:_contentController.text.trim(),
      date:widget.task.date,
      reminderTime:_selectedReminderTime,
      reminderEnabled:_selectedReminderTime!=null,
      notificationId:notificationId
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
  Future<void> _pickReminderTime() async{
    final safeInitialDate = _selectedReminderTime != null &&
              !_selectedReminderTime!.isBefore(DateTime.now())
          ? _selectedReminderTime!
          : DateTime.now();
    final date = await showDatePicker(
      context:context,
      initialDate:safeInitialDate,
      firstDate:DateTime.now(),
      lastDate:DateTime(2100),
    );
    if(date==null) return;
    final time = await showTimePicker(
      // ignore: use_build_context_synchronously
      context:context,
      initialTime:TimeOfDay.fromDateTime(_selectedReminderTime??DateTime.now()
      ),
    );
    if(time==null) return;
    setState((){
       _selectedReminderTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute
       );
    });
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
            const SizedBox(height:16),
            ListTile(
              leading: const Icon(Icons.alarm),
              title:_selectedReminderTime==null?
              const Text("Set Reminder"):
              Text(_selectedReminderTime.toString()
              ),
              trailing:Row(
                mainAxisSize:MainAxisSize.min,
                children:[
                  IconButton(
                    icon:Icon(Icons.edit) ,
                    onPressed:_pickReminderTime,
                    ),
                 if(_selectedReminderTime!=null)
                  IconButton(
                    icon:Icon(Icons.delete),
                    onPressed:(){
                      setState((){
                        _selectedReminderTime=null;
                      });
                    },
                  ),
                 
                ],

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

  
 
