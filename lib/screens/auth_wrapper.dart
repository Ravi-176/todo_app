import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/providers/auth_service_provider.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:todo_app/screens/login_screen.dart';


class AuthWrapper extends ConsumerWidget{
  const AuthWrapper({super.key});
  @override
  Widget build(BuildContext context,WidgetRef ref){
    final authState= ref.watch(authStateProvider);
    return authState.when(
    data:(user)=>user!=null?const HomeScreen():const LoginScreen(),
     error: (er,stack)=>Scaffold(body:
     Center(child: Text("Error logging in:$er"),
     )), 
     loading: ()=>Scaffold(
       body: Center
       (child:CircularProgressIndicator()),
     )
   );
  }
}
