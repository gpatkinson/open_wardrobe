import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:openwardrobe/brick/models/outfit.model.dart';
import 'package:openwardrobe/domain/repositories/abstract/outfit_repository.dart';

part 'outfit_state.dart';

class OutfitCubit extends Cubit<OutfitState> {
  final OutfitRepository _repository;
  String _currentUserProfileId = '';

  OutfitCubit(this._repository) : super(OutfitInitial());

  /// Set user profile and reload outfits
  void setUserProfile(String userProfileId) {
    if (_currentUserProfileId != userProfileId) {
      _currentUserProfileId = userProfileId;
      fetchOutfits();
    }
  }

  /// Fetch outfits for the current user profile
  Future<void> fetchOutfits() async {
    if (_currentUserProfileId.isEmpty) return;

    emit(OutfitLoading());
    try {
      final outfits = await _repository.fetchOutfits();
      emit(OutfitLoaded(outfits));
    } catch (e) {
      emit(OutfitError("Failed to load outfits: $e"));
    }
  }

  /// Add a new outfit and refresh state
  Future<void> addOutfit(Outfit outfit) async {
    try {
      await _repository.addOutfit(outfit);
      fetchOutfits(); // Refresh list
    } catch (e) {
      emit(OutfitError("Failed to add outfit: $e"));
    }
  }

}