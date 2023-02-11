import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ssas/entities/app_user.dart';
import 'package:ssas/services/user_service.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _userService = UserService();

  Stream<AppUser?> getCurrentUserStream() {
    return _auth.authStateChanges().flatMap((user) {
      if (user == null) {
        return Stream.value(null);
      }
      return _userService.getUserStreamById(user.uid);
    });
  }

  Future<AppUser?> getCurrentUser() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return null;
    }
    return await _userService.getUserById(currentUser.uid);
  }

  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signUp(String email, String password) async {
    final userCred = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await _userService.addFirebaseUser(userCred.user!);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
