import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:openwardrobe/brick/models/outfit.model.dart';
import 'package:openwardrobe/brick/models/wardrobe_item.model.dart';
import 'package:openwardrobe/repositories/app_repository.dart';
import 'package:openwardrobe/presentation/blocs/wardrobe/wardrobe_state.dart';

class WardrobeCubit extends Cubit<WardrobeState> {
  final AppRepository _appRepository = GetIt.instance<AppRepository>();

  WardrobeCubit() : super(const WardrobeInitial());

  Future<void> fetchWardrobeItems() async {
    if (state is! WardrobeLoading) {
      emit(const WardrobeLoading());
    }
    
    try {
      final items = await _appRepository.get<WardrobeItem>();
      final currentOutfits = state is WardrobeItemsAndOutfitsLoaded
          ? (state as WardrobeItemsAndOutfitsLoaded).outfits
          : [];
      
      emit(WardrobeItemsAndOutfitsLoaded(
        items: items,
        outfits: List<Outfit>.from(currentOutfits),
      ));
    } catch (e) {
      emit(WardrobeError('Failed to fetch wardrobe items: $e'));
    }
  }

  void clearCategoryFilter() {
    if (state is WardrobeItemsAndOutfitsLoaded) {
      final currentState = state as WardrobeItemsAndOutfitsLoaded;
      emit(WardrobeItemsAndOutfitsLoaded(
        items: currentState.items,
        outfits: currentState.outfits,
        selectedCategoryIds: [],
      ));
    }
  }

void toggleCategory(String categoryId) {
  if (state is WardrobeItemsAndOutfitsLoaded) {
    final currentState = state as WardrobeItemsAndOutfitsLoaded;
    final selectedCategories = List<String>.from(currentState.selectedCategoryIds ?? []);

    if (selectedCategories.contains(categoryId)) {
      selectedCategories.remove(categoryId);
    } else {
      selectedCategories.add(categoryId);
    }

    emit(WardrobeItemsAndOutfitsLoaded(
      items: currentState.items,
      outfits: currentState.outfits,
      selectedCategoryIds: selectedCategories,
    ));
  }
}

  Future<void> fetchOutfits() async {
    if (state is! WardrobeLoading) {
      emit(const WardrobeLoading());
    }
    
    try {
      final outfits = await _appRepository.get<Outfit>();
      final currentItems = state is WardrobeItemsAndOutfitsLoaded
          ? (state as WardrobeItemsAndOutfitsLoaded).items
          : [];
      
      emit(WardrobeItemsAndOutfitsLoaded(
        items: List<WardrobeItem>.from(currentItems),
        outfits: outfits,
      ));
    } catch (e) {
      emit(WardrobeError('Failed to fetch outfits: $e'));
    }
  }
}