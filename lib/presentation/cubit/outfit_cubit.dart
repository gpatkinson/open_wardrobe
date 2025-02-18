import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:openwardrobe/brick/models/outfit.model.dart';
import 'package:openwardrobe/domain/repositories/abstract/outfit_repository.dart';

part 'outfit_state.dart';

class OutfitCubit extends Cubit<OutfitState> {
  final OutfitRepository _repository;

  OutfitCubit(this._repository) : super(OutfitInitial());


  /// Fetch outfits for the current user profile
  Future<void> fetchOutfits() async {

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

  Future<void> deleteOutfit(Outfit outfit) async {
    try {
      await _repository.deleteOutfit(outfit);
      fetchOutfits(); // Refresh list
    } catch (e) {
      emit(OutfitError("Failed to add outfit: $e"));
    }
  }

}