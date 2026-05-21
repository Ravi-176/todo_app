import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/providers/auth_service_provider.dart';
import 'package:todo_app/screens/login_screen.dart';
import 'package:todo_app/widgets/responsive_helper.dart';

class RegistrationScreen extends ConsumerStatefulWidget{
  const RegistrationScreen({super.key});

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController = TextEditingController();
  bool _isLoading = false;
  void _submit()async{
    if(!_formKey.currentState!.validate()) {
      return;
    }
    //set loading state
    setState(() {
      _isLoading=true;
    });
    try{
       final authService = ref.read(authServiceProvider);
       await authService.signUp(
        _usernameEditingController.text.trim(),
        _emailEditingController.text.trim(),
        _passwordEditingController.text.trim());
        if(mounted){  
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration succesful!Please login"),
        backgroundColor: Colors.green,),
       );
       Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const LoginScreen()));
      } 
    }
    catch(e){
        if(mounted){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
    }
    finally{
      setState(() {
        _isLoading=false;
      });
    }
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body:ResponsiveHelper(builder: (context,constraints){
        final screenWidth = constraints.maxWidth;
        final isDesktop = screenWidth>900;
        final isTablet = screenWidth>600 && screenWidth<=900;
        final isMobile = screenWidth<=600;
        double getHorizontalPadding(){
          if(isDesktop) return 0.3*screenWidth;
          if(isTablet) {
            return 0.2*screenWidth;
          } else {
            return 0.15*screenWidth;
          }
        }
        double getFormWidth(){
          if(isDesktop) return 400;
          if(isTablet) return screenWidth*0.6;
          return screenWidth-48;
        }
        return Center(
          child:SingleChildScrollView(
               padding:EdgeInsets.symmetric(horizontal: getHorizontalPadding()),
               child: Container(
                padding:EdgeInsets.all(isDesktop?32:24),
                width:getFormWidth(),
                decoration:BoxDecoration(
                  color:Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isDesktop? [
                   BoxShadow(
                      color:Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    )]:[BoxShadow(
                      color:Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Form(
                key:_formKey,
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children:[
                    Icon(Icons.person_add_outlined,
                    size:isDesktop?64:48,
                    color:Colors.blue),
                    SizedBox(height:isDesktop?32:24),
                    TextFormField(
                      controller:_usernameEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration:InputDecoration(
                         labelText:"Username",
                         prefixIcon: Icon(Icons.person_add_outlined,color:Colors.deepPurple),
                         border:OutlineInputBorder(),
                      ),
                      validator:(value){
                        if(value==null||value.isEmpty){
                          return "Please enter a username";
                        }
                        if((!RegExp(r'^[a-zA-Z ]+$').hasMatch(value))){
                          return "Username can only contain alphabets and spaces";
                        }
                        return null;
                      }
                    ),
                   SizedBox(height:isDesktop?32:24),
                    TextFormField(
                      controller:_emailEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration:InputDecoration(
                         labelText:"Email",
                         prefixIcon: Icon(Icons.email_outlined,color:Colors.deepPurple),
                         border:OutlineInputBorder(),
                      ),
                      validator:(value){
                        if(value==null||value.isEmpty){
                          return "Please enter your email address";
                        }
                        if(!value.contains('@')){
                          return "Please enter a valid email";
                        }
                        return null;
                      }
                    ),
                    SizedBox(height:20,),
                    TextFormField(
                      controller:_passwordEditingController,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      decoration:InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Icons.lock_outlined,color:Colors.deepPurple),
                        border:OutlineInputBorder(),
                      ),
                      validator: (value){
                        if(value==null || value.isEmpty){
                          return "Please enter a password";
                        }
                        if(value.length<6){
                          return "Password should be atleast 6 characters!";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height:isDesktop?32:24),
                    SizedBox(
                      height:isDesktop?56:48,
                      child: ElevatedButton(
                      onPressed:_isLoading?(){}: _submit, 
                      style:ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape:RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child:_isLoading?CircularProgressIndicator():
                      Text("Register",style:TextStyle(
                        fontSize: isDesktop?18:16,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                    ),
                  ),
                   SingleChildScrollView(
                      scrollDirection:Axis.horizontal ,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          Text("Already have an account?"),
                          TextButton(onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
                          }, child: Text("Sign In",
                          style:TextStyle(color:Colors.blue)))
                        ],
                      ),
                    ),
                 
               ],
              ),
            ),
            ),
          ),
       
        );
      }),
    );
      
    
  }
}