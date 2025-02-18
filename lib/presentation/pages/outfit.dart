import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openwardrobe/presentation/cubit/outfit_cubit.dart';
import 'package:openwardrobe/core/auth/auth_service.dart';
import 'package:openwardrobe/brick/models/outfit.model.dart';

class OutfitPage extends StatelessWidget {
  const OutfitPage({super.key});

  @override
  Widget build(BuildContext context) {
    final outfitCubit = context.read<OutfitCubit>();


    return Scaffold(
      appBar: AppBar(title: Text("My Outfits")),
      body: BlocBuilder<OutfitCubit, OutfitState>(
        builder: (context, state) {
          if (state is OutfitLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is OutfitError) {
            return Center(child: Text("Error: ${state.message}"));
          } else if (state is OutfitLoaded) {
            return state.outfits.isEmpty
                ? Center(child: Text("No outfits found"))
                : ListView.builder(
                    itemCount: state.outfits.length,
                    itemBuilder: (context, index) {
                      final outfit = state.outfits[index];
                      return ListTile(
                        title: Text(outfit.name),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => outfitCubit.deleteOutfit(outfit),
                        ),
                      );
                    },
                  );
          }
          return Center(child: Text("Select a profile to load outfits"));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
            final newOutfit = Outfit(id: '', name: 'New Outfit', userProfileId: "test");
            outfitCubit.addOutfit(newOutfit);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}