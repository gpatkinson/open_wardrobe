import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openwardrobe/repositories/app_repository.dart';
import 'package:openwardrobe/brick/models/user_profile.model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController {
  final AppRepository _appRepository;

  HomeController(this._appRepository);

  Stream<List<UserProfile>> fetchUserProfile() {
    final usersStream = _appRepository.subscribe<UserProfile>();
    return usersStream;
  }
}
