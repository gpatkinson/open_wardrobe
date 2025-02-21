import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:openwardrobe/presentation/blocs/wardrobe/wardrobe_cubit.dart';
import 'package:openwardrobe/presentation/blocs/wardrobe/wardrobe_state.dart';
import 'package:openwardrobe/ui/widgets/outfit/outfit_component.dart';
import 'package:openwardrobe/ui/widgets/wardrobe_item/wardrobe_item_component.dart';

class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({super.key});

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
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
                child: Column(
                  children: [
                    if (items.isNotEmpty) ...[                        
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: items
                            .map((item) => WardrobeItemComponent(
                                  item: item,
                                  onTap: () => context.push(
                                    '/wardrobe/item/${item.id}',
                                  ),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 20),
                    ] else
                      const Center(child: Text('No items found')),
                    
                    if (outfits.isNotEmpty)
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: outfits
                            .map((outfit) => OutfitComponent(item: outfit))
                            .toList(),
                      )
                    else
                      const Center(child: Text('No outfits found')),
                    
                    const SizedBox(height: 100),
                  ],
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
