import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/providers/auth_service_provider.dart';
import 'package:todo_app/services/task_entry_service.dart';

final taskServiceProvider = Provider<TaskEntryServices>((ref)=>
                            TaskEntryServices());
//getting the entries                            
final taskEntriesProvider = StreamProvider<List<TodoTask>>((ref){
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user){
    if(user==null){
      return Stream.value([]);
    } 
    final service = ref.read(taskServiceProvider);
    return service.getTaskEntries();
  },  
   error:(er,stackTrace)=>Stream.value([]),
   loading: ()=>Stream.value([]));
  
});  
                        