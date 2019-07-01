import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignIn})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  Future<FirebaseUser> signInWithGoogle() async {
    GoogleSignInAccount account = await _googleSignIn.signIn();
    GoogleSignInAuthentication auth = await account.authentication;
    AuthCredential cred = GoogleAuthProvider.getCredential(
        idToken: auth.idToken, accessToken: auth.accessToken);
    await _firebaseAuth.signInWithCredential(cred);
    return _firebaseAuth.currentUser();
  }

  Future<void> signInWithCredentials(String email, String password) {
    return _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: email);
  }

  Future<void> signUp({String email, String password}) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async {
    return Future(() {
      _firebaseAuth.signOut();
      _googleSignIn.signOut();
    });
  }

  Future<bool> isSignedIn() async {
    FirebaseUser firebaseUser = await _firebaseAuth.currentUser();
    return firebaseUser != null;
  }

  Future<String> getUser() async {
    return (await _firebaseAuth.currentUser()).email;
  }
}
