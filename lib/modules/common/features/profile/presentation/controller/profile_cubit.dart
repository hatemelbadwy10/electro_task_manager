import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/data/error/app_exception.dart';
import '../../../auth/data/repository/auth_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthRepository authRepository;

  ProfileCubit(this.authRepository) : super(const ProfileState());

  Future<void> loadProfile() async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final user = await authRepository.me();
      emit(state.copyWith(status: ProfileStatus.success, user: user));
    } catch (error) {
      emit(
        state.copyWith(
          status: ProfileStatus.failure,
          message: error is AppException
              ? error.message
              : 'Could not load profile',
        ),
      );
    }
  }
}
