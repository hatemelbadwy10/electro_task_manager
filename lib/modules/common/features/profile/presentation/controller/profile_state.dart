import 'package:equatable/equatable.dart';

import '../../../auth/data/models/user_model.dart';

enum ProfileStatus { initial, loading, success, failure }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final UserModel? user;
  final String? message;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.user,
    this.message,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    UserModel? user,
    String? message,
  }) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, user, message];
}
