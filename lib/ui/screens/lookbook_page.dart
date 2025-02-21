import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openwardrobe/presentation/blocs/lookbook/lookbook_cubit.dart';
import 'package:openwardrobe/presentation/blocs/lookbook/lookbook_state.dart';

class LookbookPage extends StatelessWidget {
  const LookbookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LookbookCubit()..fetchLookbookItems(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lookbook'),
        ),
        body: BlocBuilder<LookbookCubit, LookbookState>(
          builder: (context, state) {
            return switch (state) {
              LookbookInitial() => const Center(
                  child: Text('Initialize your lookbook'),
                ),
              LookbookLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
              LookbookLoaded(lookbookItems: final items) => items.isEmpty
                  ? const Center(
                      child: Text('No lookbook items yet'),
                    )
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return ListTile(
                          title: Text(item.title ?? 'Unnamed Look'),
                          
                          onTap: () {
                            // TODO: Navigate to lookbook item detail page
                          },
                        );
                      },
                    ),
              LookbookError(message: final message) => Center(
                  child: Text('Error: $message'),
                ),
            };
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // TODO: Implement add new lookbook item
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}