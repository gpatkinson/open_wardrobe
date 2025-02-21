import 'package:equatable/equatable.dart';
import 'package:openwardrobe/brick/models/wardrobe_item.model.dart';

class CategoryFilterState extends Equatable {
  final List<String> selectedCategoryIds;
  final bool isLoading;

  const CategoryFilterState({
    this.selectedCategoryIds = const [],
    this.isLoading = false,
  });

  List<WardrobeItem> filterItems(List<WardrobeItem> items) {
    if (selectedCategoryIds.isEmpty) return items;
    return items.where((item) => 
      item.itemCategory != null && 
      selectedCategoryIds.contains(item.itemCategory!.id)
    ).toList();
  }

  CategoryFilterState copyWith({
    List<String>? selectedCategoryIds,
    bool? isLoading,
  }) {
    return CategoryFilterState(
      selectedCategoryIds: selectedCategoryIds ?? this.selectedCategoryIds,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [selectedCategoryIds, isLoading];
}