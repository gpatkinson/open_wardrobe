import 'package:equatable/equatable.dart';
import 'package:openwardrobe/brick/models/wardrobe_item.model.dart';
import 'package:openwardrobe/brick/models/outfit.model.dart';

sealed class WardrobeState extends Equatable {
  const WardrobeState();

  @override
  List<Object?> get props => [];
}

class WardrobeInitial extends WardrobeState {}

class WardrobeLoading extends WardrobeState {}

class WardrobeItemsAndOutfitsLoaded extends WardrobeState {
  final List<WardrobeItem> items;
  final List<Outfit> outfits;

  const WardrobeItemsAndOutfitsLoaded({required this.items, required this.outfits});

  @override
  List<Object?> get props => [items, outfits];
}

class WardrobeItemsLoaded extends WardrobeState {
  final List<WardrobeItem> items;

  const WardrobeItemsLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class OutfitsLoaded extends WardrobeState {
  final List<Outfit> outfits;

  const OutfitsLoaded(this.outfits);

  @override
  List<Object?> get props => [outfits];
}

class WardrobeError extends WardrobeState {
  final String message;

  const WardrobeError(this.message);

  @override
  List<Object?> get props => [message];
}