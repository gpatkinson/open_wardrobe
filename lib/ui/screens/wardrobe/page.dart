import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:openwardrobe/presentation/blocs/category/category_cubit.dart';
import 'package:openwardrobe/presentation/blocs/category/category_state.dart';
import 'package:openwardrobe/presentation/blocs/wardrobe/wardrobe_cubit.dart';
import 'package:openwardrobe/presentation/blocs/wardrobe/wardrobe_state.dart';
import 'package:openwardrobe/ui/widgets/category/category_component.dart';
import 'package:openwardrobe/ui/widgets/outfit/outfit_component.dart';
import 'package:openwardrobe/ui/widgets/wardrobe_item/wardrobe_item_component.dart';

class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({super.key});

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  @override
  void initState() {
    super.initState();
    // Load categories first, then wardrobe items and outfits
    _initializeData();
  }

  Future<void> _initializeData() async {
    final categoryCubit = context.read<CategoryCubit>();
    final wardrobeCubit = context.read<WardrobeCubit>();
    
    await categoryCubit.loadCategories('');
    await Future.wait([
      wardrobeCubit.fetchWardrobeItems(),
      wardrobeCubit.fetchOutfits(),
    ]);
  }

  @override
  void dispose() {
    // Dispose of any resources or controllers to prevent memory leaks
    context.read<CategoryCubit>().close();
    context.read<WardrobeCubit>().close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wardrobe')),
      body: BlocBuilder<WardrobeCubit, WardrobeState>(
        builder: (context, state) {
          if (state is WardrobeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WardrobeError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is WardrobeItemsAndOutfitsLoaded) {
            final items = state.items;
            final outfits = state.outfits;

            return SingleChildScrollView(
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (outfits.isNotEmpty) ...[                        
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            'Outfits',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: outfits.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: OutfitComponent(item: outfits[index]),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 32),
                      ] else
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 32),
                          child: const Center(child: Text('No outfits found')),
                        ),
                      BlocBuilder<CategoryCubit, CategoryState>(
                        builder: (context, categoryState) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Categories',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (categoryState.selectedCategoryIds.isNotEmpty)
                                      TextButton(
                                        onPressed: () {
                                          context.read<CategoryCubit>().clearSelection();
                                          context.read<WardrobeCubit>().clearCategoryFilter();
                                        },
                                        child: const Text('Clear Filters'),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: categoryState.categories.map((category) {
                                    final isSelected = categoryState.selectedCategoryIds.contains(category.id);
                                    return CategoryComponent(
                                      category: category,
                                      isSelected: isSelected,
                                      onTap: () {
                                        context.read<CategoryCubit>().toggleCategory(category.id);
                                        context.read<WardrobeCubit>().toggleCategory(category.id);
                                        context.read<WardrobeCubit>().fetchWardrobeItems();
                                      },
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      if (items.isNotEmpty) ...[                        
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: state.filterItemsByCategory(items)
                              .map((item) => WardrobeItemComponent(
                                    item: item,
                                    onTap: () => context.push(
                                      '/wardrobe/item/${item.id}',
                                    ),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 32),
                      ] else
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 32),
                          child: const Center(child: Text('No items found')),
                        ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
