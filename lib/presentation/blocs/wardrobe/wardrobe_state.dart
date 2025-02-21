import 'package:equatable/equatable.dart';
import 'package:openwardrobe/brick/models/wardrobe_item.model.dart';
import 'package:openwardrobe/brick/models/outfit.model.dart';

sealed class WardrobeState extends Equatable {
  final List<String> selectedCategoryIds;

  const WardrobeState({this.selectedCategoryIds = const []});

  @override
  List<Object?> get props => [selectedCategoryIds];

  List<WardrobeItem> filterItemsByCategory(List<WardrobeItem> items) {
    if (selectedCategoryIds.isEmpty) return items;
    return items.where((item) => 
      item.itemCategory != null && 
      selectedCategoryIds.contains(item.itemCategory!.id)
    ).toList();
  }

  // Outfits are not affected by category filtering
  List<Outfit> getOutfits(List<Outfit> outfits) => outfits;
}

class WardrobeInitial extends WardrobeState {
  const WardrobeInitial({super.selectedCategoryIds});
}

class WardrobeLoading extends WardrobeState {
  const WardrobeLoading({super.selectedCategoryIds});
}

class WardrobeItemsAndOutfitsLoaded extends WardrobeState {
  final List<WardrobeItem> items;
  final List<Outfit> outfits;

  const WardrobeItemsAndOutfitsLoaded({
    required this.items,
    required this.outfits,
    super.selectedCategoryIds,
  });

  @override
  List<Object?> get props => [items, outfits, selectedCategoryIds];

  WardrobeItemsAndOutfitsLoaded copyWith({
    List<WardrobeItem>? items,
    List<Outfit>? outfits,
    List<String>? selectedCategoryIds,
  }) {
    return WardrobeItemsAndOutfitsLoaded(
      items: items ?? this.items,
      outfits: outfits ?? this.outfits,
      selectedCategoryIds: selectedCategoryIds ?? this.selectedCategoryIds,
    );
  }

  List<WardrobeItem> get filteredItems => filterItemsByCategory(items);
}

class WardrobeItemsLoaded extends WardrobeState {
  final List<WardrobeItem> items;

  const WardrobeItemsLoaded(this.items, {super.selectedCategoryIds});

  @override
  List<Object?> get props => [items, selectedCategoryIds];

  List<WardrobeItem> get filteredItems => filterItemsByCategory(items);
}

class OutfitsLoaded extends WardrobeState {
  final List<Outfit> outfits;

  const OutfitsLoaded(this.outfits, {super.selectedCategoryIds});

  @override
  List<Object?> get props => [outfits, selectedCategoryIds];
}

class WardrobeError extends WardrobeState {
  final String message;

  const WardrobeError(this.message, {super.selectedCategoryIds});

  @override
  List<Object?> get props => [message, selectedCategoryIds];
}