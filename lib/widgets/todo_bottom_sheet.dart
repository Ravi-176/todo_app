import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:todo_app/models/todo_model.dart';

class TodoBottomSheet extends StatefulWidget{
  final Function(TodoTask) onSave;
  const TodoBottomSheet({required this.onSave,super.key});
  @override
  State<TodoBottomSheet> createState() => _TodoBottomSheet();
} 
  class _TodoBottomSheet extends State<TodoBottomSheet>{
    final TextEditingController _titleEditingController = TextEditingController();
    final TextEditingController _contentEditingController = TextEditingController();
 
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
                 onPressed: (){
                  TodoTask task=TodoTask(id:'5',title:_titleEditingController.text,
                  content:_contentEditingController.text,
                  date: DateFormat('dd/MM/yyyy HH:mm') .format(DateTime.now()));
                  widget.onSave(task);
                 
                  Navigator.pop(context);
                }, child: Text("Save",
                style:TextStyle(color:Colors.white)))
               ],),
              
               
                
              ],)
          ),
        );
    }
  }
