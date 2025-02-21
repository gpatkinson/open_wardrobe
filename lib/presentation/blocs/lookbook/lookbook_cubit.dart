import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:openwardrobe/brick/models/lookbook.model.dart';
import 'package:openwardrobe/repositories/app_repository.dart';
import 'package:openwardrobe/presentation/blocs/lookbook/lookbook_state.dart';

class LookbookCubit extends Cubit<LookbookState> {
  final AppRepository _appRepository = GetIt.instance<AppRepository>();

  LookbookCubit() : super(LookbookInitial());

  Future<void> fetchLookbookItems() async {
    try {
      emit(LookbookLoading());
      final lookbookItems = await _appRepository.get<Lookbook>();
      emit(LookbookLoaded(lookbookItems));
    } catch (e) {
      emit(LookbookError('Failed to fetch lookbook items: $e'));
    }
  }
}