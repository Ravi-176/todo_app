import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/models/user_model.dart';

class AuthService {
  final Ref ref;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AuthService(this.ref);
  Future<UserCredential?> signIn(String email,String password)async{
    try{
      bool userExists=await _checkUserExists(email);
      if(!userExists){
        throw Exception("User does not exist!Please register first!");
      }
      final result=await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _saveUserState(true);
      return result;
    }
    on FirebaseAuthException catch(e){
       throw("Sign in failed: ${e.code}");
    }

  }
  Future<UserCredential?> signUp(String username,String email,String password)async{
    try{
      bool userExists = await _checkUserExists(email);
      if(userExists){
        throw Exception("User already registered!Please log in!");
      }
      final result=await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await _addUserToDatabase(username, email, password);
      await _saveUserState(true);
      return result;
    }
    catch(e){
       throw("Failed to register: ${e.toString()}");
    }
  }

  Future<void> logout()async{
     await _auth.signOut();
     await _saveUserState(false);
  }
  Future<void> _addUserToDatabase(String username,String email,String password)async{
      final userId = _auth.currentUser!.uid;
      UserModel user = UserModel(username: username,email:email);
      try{
        await _firestore.collection('users').doc(userId).set(user.toMap());
      }
      catch(e){
        throw Exception("Failed to register:${e.toString()}");
      }  
  }
  Future<void> _saveUserState(bool isLoggedIn)async{
    final prefs=await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', isLoggedIn);
  }
  Future<bool> _checkUserExists(String email)async{
    try{
      final QuerySnapshot<Map<String,dynamic>> result= await _firestore.collection('users').
      where('email',isEqualTo: email).
      limit(1).get();
      return result.docs.isNotEmpty;
    }
    catch(e){
      throw Exception("Error in checking:$e");
    }
   
  }
  Future<bool> _getUserState()async{
     final prefs = await SharedPreferences.getInstance();
     return prefs.getBool('isLoggedIn')??false;
  }
}