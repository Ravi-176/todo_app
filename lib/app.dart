import 'package:flutter/material.dart';

import 'package:todo_app/screens/auth_wrapper.dart';


class MyApp extends StatelessWidget{
  const MyApp({super.key});
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title:'My Daily Tasks',
      theme:ThemeData(
        primarySwatch: Colors.blue,

      ),
      debugShowCheckedModeBanner: false,
      home:const AuthWrapper(),
    );
  }
}