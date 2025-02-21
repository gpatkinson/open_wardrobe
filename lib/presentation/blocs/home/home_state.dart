import 'package:equatable/equatable.dart';
import 'package:openwardrobe/brick/models/user_profile.model.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeUserProfileLoaded extends HomeState {
  final List<UserProfile> userProfiles;

  const HomeUserProfileLoaded(this.userProfiles);

  @override
  List<Object?> get props => [userProfiles];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}