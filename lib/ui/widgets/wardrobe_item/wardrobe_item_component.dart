import 'package:flutter/material.dart';
import 'package:openwardrobe/brick/models/wardrobe_item.model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WardrobeItemComponent extends StatelessWidget {
  static final Map<String, _SignedUrlCache> _urlCache = {};
  static const int _cacheExpirationSeconds = 3600; // 1 hour
  
  final WardrobeItem item;
  final bool isSelected;
  final VoidCallback? onTap;

  const WardrobeItemComponent({
    super.key,
    required this.item,
    this.isSelected = false,
    this.onTap,
  });

  Future<String> _getSignedUrl(String? imagePath) async {
    if (imagePath == null || item.id == null) return '';
    
    final now = DateTime.now().millisecondsSinceEpoch;
    final cacheKey = item.id!;
    final cachedUrl = _urlCache[cacheKey];

    if (cachedUrl != null && cachedUrl.expiresAt > now) {
      return cachedUrl.url;
    }

    try {
      final cleanPath = imagePath.trim().replaceAll('//', '/').replaceAll('\\', '/').replaceFirst(RegExp('^/+'), '');
      final signedUrl = await Supabase.instance.client.storage
          .from('wardrobe_items')
          .createSignedUrl(cleanPath, _cacheExpirationSeconds);
      
      _urlCache[cacheKey] = _SignedUrlCache(
        url: signedUrl,
        expiresAt: now + (_cacheExpirationSeconds * 1000),
      );

      return signedUrl;
    } catch (error) {
      debugPrint('Error signing URL: $error');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    const size = 110.00;

    return GestureDetector(
      onTap: onTap,
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
                  ? _getSignedUrl(item.imagePath!)
                  : Future.value(''),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: size,
                    width: size,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFEEEEEE), Color(0xFFE0E0E0), Color(0xFFEEEEEE)],
                                stops: [0.1, 0.5, 0.9],
                                begin: Alignment(-1.0, -0.3),
                                end: Alignment(1.0, 0.3),
                                tileMode: TileMode.mirror,
                              ),
                            ),
                          ),
                        ),
                      ),
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
                  child: CachedNetworkImage(
                    imageUrl: snapshot.data!,
                    height: size,
                    width: size,
                    fit: BoxFit.cover,
                    maxHeightDiskCache: 1024,
                    maxWidthDiskCache: 1024,
                    useOldImageOnUrlChange: true,
                    placeholder: (context, url) => Container(
                      height: size,
                      width: size,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: size,
                      width: size,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Icon(Icons.error_outline, size: 50, color: Colors.grey),
                      ),
                    ),
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

class _SignedUrlCache {
  final String url;
  final int expiresAt;

  _SignedUrlCache({required this.url, required this.expiresAt});
}