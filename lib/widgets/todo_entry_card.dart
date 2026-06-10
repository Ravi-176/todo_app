import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/providers/task_entry_provider.dart';
import 'package:todo_app/widgets/task_update_dialog.dart';


class TodoEntryCard extends ConsumerStatefulWidget{
  final TodoTask task;
  const TodoEntryCard({required this.task,super.key});

  @override
  ConsumerState<TodoEntryCard> createState() => _TodoEntryCardState();
}


class _TodoEntryCardState extends ConsumerState<TodoEntryCard> {
  @override
  Widget build(BuildContext context){
    return Card(
        margin:const EdgeInsets.symmetric(horizontal:12,vertical:8),
        color: const Color.fromARGB(232, 253, 255, 133),

        child:Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
               Text(widget.task.title,
                style:TextStyle(
                fontSize: 18,
                fontWeight:FontWeight.bold,
              )),
              const SizedBox(height:8),
              Text(widget.task.content,style:TextStyle(fontSize: 14,color:Colors.black87)),
              const SizedBox(height:8),
              Text(widget.task.date,
              style:TextStyle(fontSize: 14,color:Colors.grey)),
              const SizedBox(height: 8,),
              Row(
                mainAxisAlignment:MainAxisAlignment.end,
                children:[
                 IconButton(onPressed: ()async{
                  await ref.read(taskServiceProvider).deleteTaskEntry(widget.task);
              },
                icon:Icon(Icons.delete,
                color:Colors.red)
             ),
              IconButton(onPressed:()async{
                showDialog(
                  context: context,
                  builder:(context)=>TaskUpdateDialog(task:widget.task)
                  );                  
             },
             icon:Icon(Icons.edit,
             color:Colors.blue)
             )
            ]
          ),
             
            
           

            ]

          ),
        )
    );
  }
}