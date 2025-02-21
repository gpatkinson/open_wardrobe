import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:openwardrobe/brick/models/wardrobe_item.model.dart';
import 'package:openwardrobe/repositories/app_repository.dart';
import 'package:openwardrobe/presentation/blocs/wardrobe_item/wardrobe_item_state.dart';

class WardrobeItemCubit extends Cubit<WardrobeItemState> {
  final AppRepository _appRepository = GetIt.instance<AppRepository>();

  WardrobeItemCubit() : super(WardrobeItemInitial());

  Future<void> loadWardrobeItem(String itemId) async {
    emit(WardrobeItemLoading());
    try {
      final items = await _appRepository.get<WardrobeItem>();
      final item = items.firstWhere((item) => item.id == itemId);
      emit(WardrobeItemLoaded(item: item));
    } catch (e) {
      emit(WardrobeItemError('Failed to load wardrobe item: $e'));
    }
  }

  void toggleEditing() {
    if (state is WardrobeItemLoaded) {
      final currentState = state as WardrobeItemLoaded;
      emit(WardrobeItemLoaded(
        item: currentState.item,
        isEditing: !currentState.isEditing,
      ));
    }
  }

  Future<void> updateWardrobeItem(WardrobeItem updatedItem) async {
    if (state is WardrobeItemLoaded) {
      emit(WardrobeItemLoading());
      try {
        await _appRepository.upsert<WardrobeItem>(updatedItem);
        emit(WardrobeItemLoaded(item: updatedItem));
      } catch (e) {
        emit(WardrobeItemError('Failed to update wardrobe item: $e'));
      }
    }
  }
}