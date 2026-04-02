// Models imports
import 'package:client/core/dependencies.dart';
import 'package:client/domain/model/model.dart';

import 'auth_state.dart';
import 'auth_event.dart';

// Packages imports
import 'package:bloc/bloc.dart';

// Repos imports
import 'package:client/data/repository/auth_repository.dart';

class AppBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final Dependencies _dependencies;

  AppBloc({
    required AuthRepository authRepository,
    required Dependencies dependencies,
  }) : _authRepository = authRepository,
       _dependencies = dependencies,
       super(AuthInitial()) {
    on<AuthSignInRequested>(_onSignIn);
    on<AuthSignUpRequested>(_onSignUp);
    on<AuthSignOutRequested>(_onSignOut);
    on<AuthSubscriptionRequested>(_onSubscriptionRequest);
  }

  // Authentication handlers
  Future<void> _onSignIn(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final UserModel user = await _authRepository.signIn(
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthError(error: e.toString()));
    }
  }

  Future<void> _onSignUp(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final UserModel user = await _authRepository.signUp(
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthError(error: e.toString()));
    }
  }

  Future<void> _onSignOut(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(error: e.toString()));
    }
  }

  Future<void> _onSubscriptionRequest(
    AuthSubscriptionRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit.forEach<UserModel?>(
      _authRepository.userStream,
      onData: (data) =>
          data != null ? AuthAuthenticated(user: data) : AuthUnauthenticated(),
      onError: (e, stackTrace) => AuthError(error: e.toString()),
    );
  }
}
