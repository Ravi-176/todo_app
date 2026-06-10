import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/providers/auth_service_provider.dart';
import 'package:todo_app/providers/task_entry_provider.dart';
import 'package:todo_app/screens/login_screen.dart';
import 'package:todo_app/services/notification_service.dart';
import 'package:todo_app/widgets/todo_bottom_sheet.dart';
import 'package:todo_app/widgets/todo_entry_card.dart';

class HomeScreen extends ConsumerStatefulWidget{
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends ConsumerState<HomeScreen>{

  Future<void> _logout()async{
     final authService = ref.read(authServiceProvider);
     await authService.logout();
     // ignore: use_build_context_synchronously
     Navigator.pushAndRemoveUntil(context, 
     MaterialPageRoute(builder: (context)=>const LoginScreen()), (route)=>false);
  }
  @override
  Widget build(BuildContext context){
    final taskEntriesValue = ref.watch(taskEntriesProvider);
    return Scaffold(
      appBar: AppBar( 
        title:Text("My Daily Tasks"),
        actions:[
          IconButton(onPressed: _logout, icon: Icon(Icons.logout))
        ]),
      body:taskEntriesValue.when(
        data:(taskEntries){
           if(taskEntries.isEmpty){
            return Center(
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.book_outlined,size:64,color:Colors.grey),
                  const SizedBox(height:16),
                  Text("No task entries yet!",
                  style:Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height:10),
                  Text("Tap the + button to add your todo tasks!",
                  style:Theme.of(context).textTheme.bodyMedium?.copyWith(color:Colors.grey[600]))
                ],)
            );
           }
           return ListView.builder(
            itemCount: taskEntries.length,
            itemBuilder: (context,index){
              return TodoEntryCard(task: taskEntries[index]);
            });
      },
      error:(error,stackTrace){
        return Center(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Icon(Icons.error_outlined,size:64,color:Colors.red),
              const SizedBox(height:16),
              Text("Error loading tasks!"
              ,style:Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height:10),
              Text(error.toString(),
              style:Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,)
            ],
        )
       );
      },
      loading:()=>const Center(child:CircularProgressIndicator()
      )),
      floatingActionButton: FloatingActionButton(
      onPressed: (){
        showModalBottomSheet(
          context:context,
          isScrollControlled: true,
          shape:RoundedRectangleBorder(
            borderRadius:const BorderRadius.vertical(top:Radius.circular(20)),
          ),
          builder:(context){
            return TodoBottomSheet(
              onSave: (taskEntry)async{
                try{
                final service = ref.read(taskServiceProvider);
                await service.addTaskEntry(taskEntry);
                if(taskEntry.reminderEnabled&&taskEntry.reminderTime!=null){
                  await NotificationService().scheduleNotification(id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
                   title: taskEntry.title,
                   body: taskEntry.content,
                   scheduledTime: taskEntry.reminderTime!
                   );
                }
              }
              catch(e){
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).
                showSnackBar(SnackBar(content: Text("Error saving task:$e",
                style:TextStyle(color:Colors.white)),
                backgroundColor: Colors.red,));
              }
            }
              
              
            );
            
          }
        );
      },
      backgroundColor: const Color.fromARGB(255, 239, 235, 8),
      child:Icon(Icons.add,color:Colors.black)),
    );
  }
}