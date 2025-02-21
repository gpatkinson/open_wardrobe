import 'package:equatable/equatable.dart';
import 'package:openwardrobe/brick/models/lookbook.model.dart';

sealed class LookbookState extends Equatable {
  const LookbookState();

  @override
  List<Object?> get props => [];
}

class LookbookInitial extends LookbookState {}

class LookbookLoading extends LookbookState {}

class LookbookLoaded extends LookbookState {
  final List<Lookbook> lookbookItems;

  const LookbookLoaded(this.lookbookItems);

  @override
  List<Object?> get props => [lookbookItems];
}

class LookbookError extends LookbookState {
  final String message;

  const LookbookError(this.message);

  @override
  List<Object?> get props => [message];
}