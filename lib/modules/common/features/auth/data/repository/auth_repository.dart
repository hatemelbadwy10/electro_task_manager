import '../../../../../../core/data/storage/token_storage.dart';
import '../datasource/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final TokenStorage tokenStorage;

  AuthRepository({required this.remoteDataSource, required this.tokenStorage});

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await remoteDataSource.login(
      email: email,
      password: password,
    );
    await tokenStorage.saveToken(response.token);
    return response.user;
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await remoteDataSource.register(
      name: name,
      email: email,
      password: password,
    );
    await tokenStorage.saveToken(response.token);
    return response.user;
  }

  Future<UserModel> me() => remoteDataSource.me();

  Future<String?> readToken() => tokenStorage.readToken();

  Future<void> logout() => tokenStorage.clearToken();
}
