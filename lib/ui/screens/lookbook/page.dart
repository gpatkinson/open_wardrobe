import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openwardrobe/brick/models/lookbook.model.dart';
import 'package:openwardrobe/ui/widgets/lookbook/lookbook_component.dart';
import 'package:openwardrobe/controllers/lookbook_controller.dart';

class LookbookScreen extends StatelessWidget {
  LookbookScreen({super.key});

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
                    child: BlocBuilder<LookbookController, List<Lookbook>>(
                      builder: (context, lookbookItems) {
                        if (lookbookItems.isEmpty) {
                          return const Center(child: CircularProgressIndicator());
                        } else {
                          return SingleChildScrollView(
                            child: Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              alignment: WrapAlignment.start,
                              children: lookbookItems.map((item) => 
                                Container(
                                  width: 150,
                                  child: LookbookComponent(item: item),
                                )
                              ).toList(),
                            ),
                          );
                        }
                      }
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}
