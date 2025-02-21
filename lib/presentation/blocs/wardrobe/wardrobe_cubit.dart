import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:openwardrobe/brick/models/outfit.model.dart';
import 'package:openwardrobe/brick/models/wardrobe_item.model.dart';
import 'package:openwardrobe/repositories/app_repository.dart';
import 'package:openwardrobe/presentation/blocs/wardrobe/wardrobe_state.dart';

class WardrobeCubit extends Cubit<WardrobeState> {
  final AppRepository _appRepository = GetIt.instance<AppRepository>();

  WardrobeCubit() : super(WardrobeInitial());

  Future<void> fetchWardrobeItems() async {
    if (state is! WardrobeLoading) {
      emit(WardrobeLoading());
    }
    
    try {
      final items = await _appRepository.get<WardrobeItem>();
      final currentOutfits = state is WardrobeItemsAndOutfitsLoaded
          ? (state as WardrobeItemsAndOutfitsLoaded).outfits
          : [];
      
      emit(WardrobeItemsAndOutfitsLoaded(items: List<WardrobeItem>.from(items), outfits: List<Outfit>.from(currentOutfits)));
    } catch (e) {
      emit(WardrobeError('Failed to fetch wardrobe items: $e'));
    }
  }

  Future<void> fetchOutfits() async {
    if (state is! WardrobeLoading) {
      emit(WardrobeLoading());
    }
    
    try {
      final outfits = await _appRepository.get<Outfit>();
      final currentItems = state is WardrobeItemsAndOutfitsLoaded
          ? (state as WardrobeItemsAndOutfitsLoaded).items
          : [];
      
      emit(WardrobeItemsAndOutfitsLoaded(items: List<WardrobeItem>.from(currentItems), outfits: outfits));
    } catch (e) {
      emit(WardrobeError('Failed to fetch outfits: $e'));
    }
  }

  Future<void> fetchWardrobeItemCount() async {
    try {
      emit(WardrobeLoading());
      final items = await _appRepository.get<WardrobeItem>();
      emit(WardrobeItemsLoaded(items));
    } catch (e) {
      emit(WardrobeError('Failed to fetch wardrobe item count: $e'));
    }
  }
}