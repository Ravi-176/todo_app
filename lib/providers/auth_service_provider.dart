import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';
import 'package:todo_app/services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref)=>AuthService(ref));
//adding state provider
final authStateProvider = StreamProvider<User?>(
    (ref)=>FirebaseAuth.instance.authStateChanges(),
   );