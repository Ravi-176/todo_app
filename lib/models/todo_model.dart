import 'package:cloud_firestore/cloud_firestore.dart';

class TodoTask{
  final String id;
  final String title;
  final String content;
  final String date;
  final DateTime? reminderTime;
  final bool reminderEnabled;
  final int? notificationId;
  TodoTask({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    this.reminderTime,
    this.reminderEnabled=false,
    this.notificationId,
  });
  Map<String,dynamic> toMap(){
    return {
      'title':title,
      'content':content,
      'date':date,
      'reminderTime':reminderTime,
      'reminderEnabled':reminderEnabled,
      'notificationId':notificationId,
    };
  }
  factory TodoTask.fromFirestore(DocumentSnapshot doc){
    final data = doc.data() as Map<String,dynamic>;
    return TodoTask(
    id: doc.id, 
    title: data['title'], 
    content: data['content'],
    date: data['date'],
    reminderTime:data['reminderTime'] != null
          ? (data['reminderTime'] as Timestamp).toDate()
          : null,
    reminderEnabled:data['reminderEnabled'] ?? false,    
    notificationId:data['notificationId']
    );
  }
    
  
}