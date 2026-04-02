import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:client/domain/model/model.dart';

class AuthRepository {

  final firebase.FirebaseAuth _auth = firebase.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<UserModel?> get userStream {
    return _auth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) {
        return null;
      }
      return await _fetchUserFromFirestore(firebaseUser);
    });
  }

  Future<UserModel> signUp({required String email, required String password}) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = credential.user;
      if (firebaseUser == null) throw Exception("Ошибка создания пользователя");

      final newUser = UserModel(
        id: firebaseUser.uid,
        email: email,
        role: UserRole.student,
      );

      await _firestore.collection('users').doc(newUser.id).set(newUser.toFirestore());

      return newUser;
    } on firebase.FirebaseAuthException catch (e) {
      throw Exception('Ошибка регистрации: ${e.message}');
    }
  }

  Future<UserModel> signIn({required String email, required String password}) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = credential.user;
      if (firebaseUser == null) throw Exception("Пользователь не найден");

      return await _fetchUserFromFirestore(firebaseUser);
    } on firebase.FirebaseAuthException catch (e) {
      throw Exception('Ошибка входа: ${e.message}');
    }
  }

  Future<String?> getToken() async {
    final firebaseUser = _auth.currentUser;
    return await firebaseUser?.getIdToken(); 
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<UserModel> _fetchUserFromFirestore(firebase.User firebaseUser) async {
    try {
      final doc = await _firestore.collection('users').doc(firebaseUser.uid).get();
      
      if (doc.exists && doc.data() != null) {
        return UserModel.fromFirestore(doc.id, doc.data()!);
      }
    } catch (e) {
      print('Ошибка чтения из Firestore: $e'); //todo изменить на логирование
    }
    
    return UserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      role: UserRole.student,
    );
  }
}