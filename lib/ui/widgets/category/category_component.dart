import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openwardrobe/brick/models/category_summary.model.dart';
import 'package:openwardrobe/brick/models/item_category.model.dart';
import 'package:openwardrobe/presentation/blocs/category/category_cubit.dart';
import 'package:openwardrobe/presentation/blocs/category/category_state.dart';


class CategoryComponent extends StatelessWidget {
  final ItemCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryComponent({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(6)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Theme.of(context).primaryColor : null,
                    ),
                  ),
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryFilterGrid extends StatelessWidget {
  const CategoryFilterGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.error != null) {
          return Center(child: Text(state.error!));
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: state.categories.length,
          itemBuilder: (context, index) {
            final category = state.categories[index];
            final isSelected = context.read<CategoryCubit>().isCategorySelected(category.id);

            return CategoryComponent(
              category: category,
              isSelected: isSelected,
              onTap: () => context.read<CategoryCubit>().toggleCategory(category.id),
            );
          },
        );
      },
    );
  }
}