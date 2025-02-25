import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openwardrobe/brick/models/lookbook.model.dart';
import 'package:openwardrobe/presentation/blocs/lookbook/lookbook_cubit.dart';
import 'package:openwardrobe/presentation/blocs/lookbook/lookbook_state.dart';
import 'package:openwardrobe/ui/widgets/lookbook/lookbook_component.dart';

class LookbookScreen extends StatefulWidget {
  const LookbookScreen({super.key});

  @override
  _LookbookScreenState createState() => _LookbookScreenState();
}

class _LookbookScreenState extends State<LookbookScreen> {
  @override
  void initState() {
    super.initState();
    context.read<LookbookCubit>().fetchLookbookItems();
  }

  @override
  void dispose() {
    context.read<LookbookCubit>().close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lookbook'),
      ),
      body: SingleChildScrollView(
        child: IntrinsicHeight(
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: BlocBuilder<LookbookCubit, LookbookState>(
                      builder: (context, state) {
                        return switch (state) {
                          LookbookLoading() => const Center(
                              child: CircularProgressIndicator(),
                            ),
                          LookbookError(message: var message) => Center(
                              child: Text('Error: $message'),
                            ),
                          LookbookLoaded(lookbookItems: final items) => items.isEmpty
                              ? const Center(child: Text('No items found'))
                              : SingleChildScrollView(
                                  child: Wrap(
                                    spacing: 8.0,
                                    runSpacing: 8.0,
                                    alignment: WrapAlignment.start,
                                    children: items.map((item) => Container(
                                          width: 150,
                                          child: LookbookComponent(item: item),
                                        )).toList(),
                                  ),
                                ),
                          LookbookInitial() => const Center(
                              child: CircularProgressIndicator(),
                            ),
                        };
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
