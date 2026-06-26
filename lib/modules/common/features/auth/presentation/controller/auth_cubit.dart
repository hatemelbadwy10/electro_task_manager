import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/data/error/app_exception.dart';
import '../../data/repository/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repository;

  AuthCubit(this.repository) : super(const AuthState());

  Future<void> checkSession() async {
    emit(state.copyWith(status: AuthStatus.loading));
    final token = await repository.readToken();
    if (token == null || token.isEmpty) {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
      return;
    }

    try {
      final user = await repository.me();
      emit(state.copyWith(status: AuthStatus.authenticated, user: user));
    } catch (_) {
      await repository.logout();
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  Future<void> login({required String email, required String password}) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final user = await repository.login(email: email, password: password);
      emit(state.copyWith(status: AuthStatus.authenticated, user: user));
    } catch (error) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          message: error is AppException ? error.message : 'Login failed',
        ),
      );
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final user = await repository.register(
        name: name,
        email: email,
        password: password,
      );
      emit(state.copyWith(status: AuthStatus.authenticated, user: user));
    } catch (error) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          message: error is AppException
              ? error.message
              : 'Registration failed',
        ),
      );
    }
  }

  Future<void> logout() async {
    await repository.logout();
    emit(state.copyWith(status: AuthStatus.unauthenticated));
  }
}
