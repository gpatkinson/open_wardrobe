import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:openwardrobe/brick/models/category_summary.model.dart';
import 'package:openwardrobe/brick/models/item_category.model.dart';
import 'package:openwardrobe/repositories/app_repository.dart';
import 'package:openwardrobe/presentation/blocs/category/category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
   final AppRepository _repository = GetIt.instance<AppRepository>();


  CategoryCubit() : super(CategoryState());

  Future<void> loadCategories(String userId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final categories = await _repository.get<ItemCategory>();
      
      // Create a map to store unique categories by name
      final Map<String, ItemCategory> uniqueCategories = {};
      for (var category in categories) {
        uniqueCategories[category.name] = category;
      }
      
      emit(state.copyWith(
        categories: uniqueCategories.values.toList(),
        isLoading: false,
        selectedCategoryIds: [],
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isLoading: false,
      ));
    }
  }

  void toggleCategory(String categoryId) {
    final currentSelected = List<String>.from(state.selectedCategoryIds);
    if (currentSelected.contains(categoryId)) {
      currentSelected.remove(categoryId);
    } else {
      currentSelected.add(categoryId);
    }
    emit(state.copyWith(selectedCategoryIds: currentSelected));
  }

  void clearSelection() {
    emit(state.copyWith(selectedCategoryIds: []));
  }

  bool isCategorySelected(String categoryId) {
    return state.selectedCategoryIds.contains(categoryId);
  }
}