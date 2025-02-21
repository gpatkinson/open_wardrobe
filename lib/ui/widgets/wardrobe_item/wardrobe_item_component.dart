import 'package:flutter/material.dart';
import 'package:openwardrobe/brick/models/wardrobe_item.model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WardrobeItemComponent extends StatelessWidget {
  final WardrobeItem item;
  final bool isSelected;
  final VoidCallback? onTap; // New: Callback to toggle selection

  const WardrobeItemComponent({
    super.key,
    required this.item,
    this.isSelected = false, // Default: Not selected
    this.onTap, // New: Function to toggle selection
  });

  @override
  Widget build(BuildContext context) {
    const size = 110.00;

    return GestureDetector( // New: Wrap in GestureDetector
      onTap: onTap, // Call the function when tapped
      child: Container(
        decoration: BoxDecoration(
          border: isSelected ? Border.all(color: Colors.blue, width: 2) : null,
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.blue.withOpacity(0.5), blurRadius: 8, spreadRadius: 1)]
              : null,
        ),
        child: Column(
          children: [
            FutureBuilder<String>(              
              future: item.imagePath != null
                  ? Supabase.instance.client.storage
                      .from('wardrobe_items')
                      .createSignedUrl(
                        item.imagePath!.trim().replaceAll('//', '/').replaceAll('\\', '/').replaceFirst(RegExp('^/+'), ''),
                        3600
                      )
                      .catchError((error) {
                        debugPrint('Error signing URL: $error');
                        return '';
                      })
                  : Future.value(''),
                  
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: size,
                    width: size,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty || item.imagePath == null) {
                  return Container(
                    height: size,
                    width: size,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                    ),
                  );
                }

                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    snapshot.data!,
                    height: size,
                    width: size,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: size,
                        width: size,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Icon(Icons.error_outline, size: 50, color: Colors.grey),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: size,
                        width: size,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}