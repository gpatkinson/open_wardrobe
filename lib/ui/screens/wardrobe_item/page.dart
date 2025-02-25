import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openwardrobe/brick/models/wardrobe_item.model.dart';
import 'package:openwardrobe/presentation/blocs/wardrobe_item/wardrobe_item_cubit.dart';
import 'package:openwardrobe/presentation/blocs/wardrobe_item/wardrobe_item_state.dart';
import 'package:openwardrobe/ui/widgets/wardrobe_item/wardrobe_item_component.dart';
import 'package:collection/collection.dart';
import 'package:openwardrobe/presentation/blocs/category/category_cubit.dart'; // Added import
import 'package:openwardrobe/presentation/blocs/category/category_state.dart'; // Added import

class WardrobeItemPage extends StatelessWidget {
  final String itemId;

  const WardrobeItemPage({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => WardrobeItemCubit()..loadWardrobeItem(itemId),
        ),
        BlocProvider(
          create: (context) => CategoryCubit()..loadCategories('userId'), // Replace 'userId' with actual userId
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Wardrobe Item'),
          actions: [
            BlocBuilder<WardrobeItemCubit, WardrobeItemState>(
              builder: (context, state) {
                if (state is WardrobeItemLoaded) {
                  return IconButton(
                    icon: Icon(state.isEditing ? Icons.save : Icons.edit),
                    onPressed: () {
                      if (state.isEditing) {
                        // Save changes
                        context
                            .read<WardrobeItemCubit>()
                            .updateWardrobeItem(state.item);
                      }
                      context.read<WardrobeItemCubit>().toggleEditing();
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: BlocBuilder<WardrobeItemCubit, WardrobeItemState>(
          builder: (context, state) {
            if (state is WardrobeItemLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is WardrobeItemError) {
              return Center(child: Text(state.message));
            } else if (state is WardrobeItemLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.width,
                        child: WardrobeItemComponent(
                          item: state.item,
                          size: MediaQuery.of(context).size.width,
                          isSelected: false,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (state.isEditing)
                      ..._buildEditingFields(context, state.item)
                    else
                      ..._buildViewFields(state.item),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  List<Widget> _buildEditingFields(BuildContext context, WardrobeItem item) {
    return [
      TextFormField(
        initialValue: item.brand?.name ?? '',
        decoration: const InputDecoration(
          labelText: 'Brand',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          // TODO: Update brand
        },
      ),
      const SizedBox(height: 16),
      BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const CircularProgressIndicator();
          } else if (state.error != null) {
            return Text('Error: ${state.error}');
          } else {
            return DropdownMenu<String>(
              initialSelection: item.itemCategory?.name ?? '',
              onSelected: (String? value) {
                // TODO: Update category
              },
              dropdownMenuEntries: UnmodifiableListView<DropdownMenuEntry<String>>(
                state.categories.map<DropdownMenuEntry<String>>(
                  (category) => DropdownMenuEntry(value: category.name, label: category.name),
                ),
              ),
            );
          }
        },
      ),
    ];
  }

  List<Widget> _buildViewFields(WardrobeItem item) {
    return [
      Text(
        'Brand: ${item.brand?.name ?? 'Not specified'}',
        style: const TextStyle(fontSize: 18),
      ),
      const SizedBox(height: 8),
      Text(
        'Category: ${item.itemCategory?.name ?? 'Not specified'}',
        style: const TextStyle(fontSize: 18),
      ),
      const SizedBox(height: 8),
      Text(
        'Created: ${item.createdAt?.toString() ?? 'Unknown'}',
        style: const TextStyle(fontSize: 16, color: Colors.grey),
      ),
    ];
  }
}
