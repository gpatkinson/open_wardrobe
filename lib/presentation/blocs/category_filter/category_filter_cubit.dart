import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openwardrobe/presentation/blocs/category_filter/category_filter_state.dart';

class CategoryFilterCubit extends Cubit<CategoryFilterState> {
  CategoryFilterCubit() : super(const CategoryFilterState());

  void toggleCategory(String categoryId) {
    final currentSelected = List<String>.from(state.selectedCategoryIds);
    
    if (currentSelected.contains(categoryId)) {
      currentSelected.remove(categoryId);
    } else {
      currentSelected.add(categoryId);
    }

    emit(state.copyWith(selectedCategoryIds: currentSelected));
  }

  void clearFilter() {
    emit(state.copyWith(selectedCategoryIds: const []));
  }

  void setLoading(bool isLoading) {
    emit(state.copyWith(isLoading: isLoading));
  }
}