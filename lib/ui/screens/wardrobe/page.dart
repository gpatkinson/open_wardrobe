import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openwardrobe/brick/models/outfit.model.dart';
import 'package:openwardrobe/brick/models/wardrobe_item.model.dart';
import 'package:openwardrobe/controllers/wardrobe_controller.dart';
import 'package:openwardrobe/ui/widgets/outfit/outfit_component.dart';
import 'package:openwardrobe/ui/widgets/wardrobe_item/wardrobe_item_component.dart';

class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({super.key});

  @override
  _WardrobeScreenState createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  late WardrobeController wardrobeController;

  @override
  void initState() {
    super.initState();
    wardrobeController = context.read<WardrobeController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wardrobe')),
      body: BlocBuilder<WardrobeController, List<WardrobeItem>>(
        builder: (context, wardrobeItems) {
          if (wardrobeItems.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return SingleChildScrollView(
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: wardrobeItems
                          .map((item) => WardrobeItemComponent(item: item))
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<WardrobeController, List<Outfit>>(
                      builder: (context, outfits) {
                        if (outfits.isEmpty) {
                          return const Center(child: CircularProgressIndicator());
                        } else {
                          return Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: outfits
                                .map((outfit) => OutfitComponent(item: outfit))
                                .toList(),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
