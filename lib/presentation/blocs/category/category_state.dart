import 'package:openwardrobe/brick/models/item_category.model.dart';

class CategoryState {
  final List<ItemCategory> categories;
  final List<String> selectedCategoryIds;
  final bool isLoading;
  final String? error;

  CategoryState({
    this.categories = const [],
    this.selectedCategoryIds = const [],
    this.isLoading = false,
    this.error,
  });

  CategoryState copyWith({
    List<ItemCategory>? categories,
    List<String>? selectedCategoryIds,
    bool? isLoading,
    String? error,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      selectedCategoryIds: selectedCategoryIds ?? this.selectedCategoryIds,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}