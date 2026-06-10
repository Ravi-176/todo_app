import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/services/notification_service.dart';

class TaskEntryServices{
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    //add task entry
    Future<void> addTaskEntry(TodoTask task)async{
        final user = _auth.currentUser;
        if(user==null){
          throw Exception("User not logged in!");
        }
      
        await _firestore.collection('users').
        doc(user.uid).collection('tasks').add(task.toMap());
       
       
       
    }
    
    //get task entry
    Stream<List<TodoTask>> getTaskEntries(){
        final user = _auth.currentUser;
        if(user==null){
            throw Exception("User not logged in");
        }
        return _firestore.
        collection('users').
        doc(user.uid).
        collection('tasks').
        snapshots().map(
            (snapshot)=>snapshot.docs.map(
                (doc)=>TodoTask.fromFirestore(doc)
            ).toList()
        );
    }
    Future<void> deleteTaskEntry(TodoTask task)async{
        
        final user = _auth.currentUser;
        if(user==null){
            throw Exception("User not logged in");
        }
        //cancel notification if exists
        await NotificationService().notifications.cancel(id: task.notificationId!);
        await _firestore.collection('users').
        doc(user.uid).collection('tasks').doc(task.id).delete();
    }
    Future<void> updateTaskEntry(String taskId,TodoTask updatedTask)async{
        final user = _auth.currentUser;
        if(user==null){
           throw Exception("User not logged in");
        }
        await _firestore.collection('users').doc(user.uid).
               collection('tasks').
               doc(taskId).update(updatedTask.toMap());

    
}
          

}   

