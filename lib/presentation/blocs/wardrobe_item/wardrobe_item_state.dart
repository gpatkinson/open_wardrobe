import 'package:openwardrobe/brick/models/wardrobe_item.model.dart';

abstract class WardrobeItemState {}

class WardrobeItemInitial extends WardrobeItemState {}

class WardrobeItemLoading extends WardrobeItemState {}

class WardrobeItemLoaded extends WardrobeItemState {
  final WardrobeItem item;
  final bool isEditing;

  WardrobeItemLoaded({
    required this.item,
    this.isEditing = false,
  });
}

class WardrobeItemError extends WardrobeItemState {
  final String message;

  WardrobeItemError(this.message);
}