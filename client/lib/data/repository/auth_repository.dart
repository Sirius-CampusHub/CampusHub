import 'package:dio/dio.dart';
import 'package:client/domain/model/model.dart';
import 'package:client/data/source/source.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;


class AuthRepository {
  final FirebaseAuthDataSource _authDataSource;
  final UserFirestoreDataSource _firestoreDataSource;
  final Dio _dio;

  AuthRepository({
    required FirebaseAuthDataSource authDataSource,
    required UserFirestoreDataSource firestoreDataSource,
    required Dio dio,
  })  : _authDataSource = authDataSource,
        _firestoreDataSource = firestoreDataSource,
        _dio = dio;

  Stream<UserModel?> get userStream {
    return _authDataSource.authStateChanges.asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      return await _fetchUserOrCreateDefault(firebaseUser.uid, firebaseUser.email);
    });
  }

  Future<UserModel> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final firebaseUser = await _authDataSource.signUp(email: email, password: password);
      final rawToken = await _authDataSource.getToken();

      try {
        // TODO: ВЫНЕСТИ ССЫЛКУ в константы / env
        await _dio.post(
          'https://siriusapi.kod.polytech-schedule.ru/auth/init',
          options: Options(
            headers: {
              'Authorization': 'Bearer $rawToken',
            },
          ),
        );
      } on DioException catch (dioError) {
        await _authDataSource.deleteCurrentUser();
        final errorMessage = dioError.response?.data?['detail'] ?? dioError.message;
        print("Ошибка инициализации на сервере: $errorMessage");
        rethrow;
      }
      
      await _authDataSource.getToken(forceRefresh: true);

      //String? token = await _authDataSource.getToken(forceRefresh: true);
      //print("Bearer "+ token.toString());

      final newUser = UserModel(
        id: firebaseUser.uid,
        email: email,
        role: UserRole.student,
      );
      await _firestoreDataSource.saveUser(newUser);

      return newUser;
    } on firebase.FirebaseAuthException catch (e) {
      print('Ошибка при регистрации.');
      rethrow;
    } catch (e) {
      // TODO: Логирование
      rethrow;
    }
  }

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final firebaseUser = await _authDataSource.signIn(email: email, password: password);
      var auth = await _fetchUserOrCreateDefault(firebaseUser.uid, firebaseUser.email);

      //String? token = await _authDataSource.getToken(forceRefresh: true);
      //print("Bearer "+ token.toString());

      return auth;
    } catch (e) {
      // TODO: Логирование
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _authDataSource.signOut();
  }

  Future<UserModel> _fetchUserOrCreateDefault(String uid, String? email) async {
    final userModel = await _firestoreDataSource.getUser(uid);
    
    if (userModel != null) {
      return userModel;
    }

    return UserModel(
      id: uid,
      email: email ?? '',
      role: UserRole.student,
    );
  }
}