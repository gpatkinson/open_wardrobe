import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:openwardrobe/repositories/app_repository.dart';
import 'package:openwardrobe/presentation/blocs/home/home_state.dart';
import 'package:openwardrobe/brick/models/user_profile.model.dart';

class HomeCubit extends Cubit<HomeState> {
  final AppRepository _appRepository = GetIt.instance<AppRepository>();

  HomeCubit() : super(HomeInitial());

  Future<void> fetchUserProfile() async {
    try {
      emit(HomeLoading());
      final userProfiles = await _appRepository.get<UserProfile>();
      emit(HomeUserProfileLoaded(userProfiles));
    } catch (e) {
      emit(HomeError('Failed to fetch user profile: $e'));
    }
  }
}