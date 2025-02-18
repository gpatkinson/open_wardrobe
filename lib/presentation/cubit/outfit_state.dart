part of 'outfit_cubit.dart';

@immutable
sealed class OutfitState {}

/// Initial state before any data is loaded
final class OutfitInitial extends OutfitState {}

/// Loading state while fetching data
final class OutfitLoading extends OutfitState {}

/// Loaded state when outfits are successfully retrieved
final class OutfitLoaded extends OutfitState {
  final List<Outfit> outfits;

  OutfitLoaded(this.outfits);
}

/// Error state for handling failures
final class OutfitError extends OutfitState {
  final String message;

  OutfitError(this.message);
}