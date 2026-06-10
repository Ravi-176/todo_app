import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/services/notification_service.dart';

class TodoBottomSheet extends StatefulWidget{
  final Function(TodoTask) onSave;
  const TodoBottomSheet({required this.onSave,super.key});
  @override
  State<TodoBottomSheet> createState() => _TodoBottomSheet();
} 
  class _TodoBottomSheet extends State<TodoBottomSheet>{
    final TextEditingController _titleEditingController = TextEditingController();
    final TextEditingController _contentEditingController = TextEditingController();
    DateTime? selectedReminder;
    @override
    Widget build(BuildContext context){
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: EdgeInsets.all(16),
            color:Colors.white,
            child:Column(
              children: [
                //Title
                TextField(
                  controller: _titleEditingController,
                  decoration:InputDecoration(
                    border:OutlineInputBorder(),
                    labelText: "Title",
                  )
                ),
               const SizedBox(height:20),
               TextField(
                controller:_contentEditingController,
                decoration:InputDecoration(
                  border:OutlineInputBorder(),
                  labelText: "Content",
                )
               ) ,
               const SizedBox(height:20),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                OutlinedButton(
                  style:OutlinedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                  }
                , child: Text('Cancel',style:TextStyle(color:Colors.white))),
                OutlinedButton(
                 style:OutlinedButton.styleFrom(
                  backgroundColor: Colors.green,
                 ) ,
                 onPressed: ()async{
                  final notificationId = DateTime.now().millisecondsSinceEpoch.remainder(100000);

                  final task=TodoTask(
                  id:'',
                  title:_titleEditingController.text,
                  content:_contentEditingController.text,
                  date: DateFormat('dd/MM/yyyy HH:mm') .format(DateTime.now()),
                  reminderTime:selectedReminder,
                  reminderEnabled:selectedReminder!=null,
                  notificationId:notificationId
                  );
                  try{
                      
                      widget.onSave(task);
                      if(task.reminderEnabled&&task.reminderTime!=null){
                         await NotificationService().scheduleNotification(
                         id: notificationId, 
                         title: task.title, 
                         body: task.content,
                         scheduledTime:selectedReminder!);
                      }
                      if(!task.reminderEnabled){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content:Text("No reminder added!You can add one later!"),backgroundColor:Colors.orange)
                          );
                      }
                     if(mounted)   {
                      Navigator.pop(context);
                     }                  
                   
                  }
                  catch(e){
                    throw Exception("Error:$e");
                  }
                
                  
                 
                  // ignore: use_build_context_synchronously
                 
                }, child: Text("Save",
                style:TextStyle(color:Colors.white)))
               ],),
              const SizedBox(height:20),
              //Reminder button
              OutlinedButton(
                onPressed:()async{
                  final date = await showDatePicker(
                    context:context,
                    initialDate:DateTime.now(),
                    firstDate:DateTime.now(),
                    lastDate:DateTime(2100),
                  );
                  if(date==null) return;
                  final time = await showTimePicker(
                    // ignore: use_build_context_synchronously
                    context:context,
                    initialTime:TimeOfDay.now(),
                  );
                  if(time==null) return;
                  setState((){
                     selectedReminder = DateTime(
                       date.year,
                       date.month,
                       date.day,
                       time.hour,
                       time.minute
                     );
                  });
                },
                child:Text("Set Reminder"),
              ),
               //display selected reminder date time
               if(selectedReminder!=null)
                Text("Reminder set for :${DateFormat('dd MMM yyyy hh:mm a').format(selectedReminder!)}"),              
                
              ],)
          ),
        );
    }
  }
