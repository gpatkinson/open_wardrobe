import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../models/wardrobe_item.dart';
import '../models/item_category.dart';
import '../models/outfit.dart';

class WardrobeRepository {
  // ==================== WARDROBE ITEMS ====================

  Future<List<WardrobeItem>> fetchItems() async {
    final isOnline = await _checkConnectivity();
    
    if (isOnline) {
      try {
        final userId = pb.authStore.model?.id;
        if (userId == null) {
          return await _fetchItemsFromLocal();
        }

        final records = await pb.collection('wardrobe').getFullList(
          filter: 'user = "$userId"',
          sort: '-created',
        );
        
        final items = records.map((record) => 
          WardrobeItem.fromPocketBase(record, baseUrl: pb.baseUrl)
        ).toList();
        await _cacheItemsLocally(items);
        return items;
      } catch (error) {
        print('Error fetching items: $error');
        return await _fetchItemsFromLocal();
      }
    } else {
      return await _fetchItemsFromLocal();
    }
  }

  Future<WardrobeItem> addItem({
    required String name,
    String? categoryId,
    List<int>? imageBytes,
    String? imageName,
  }) async {
    final userId = pb.authStore.model?.id;
    
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final body = <String, dynamic>{
      'name': name,
      'user': userId,
    };
    
    if (categoryId != null) {
      body['category'] = categoryId;
    }

    final List<http.MultipartFile> files = [];
    if (imageBytes != null && imageName != null) {
      files.add(http.MultipartFile.fromBytes('image', imageBytes, filename: imageName));
    }

    final record = await pb.collection('wardrobe').create(
      body: body,
      files: files,
    );
    
    final item = WardrobeItem.fromPocketBase(record, baseUrl: pb.baseUrl);
    await _saveItemLocally(item);
    return item;
  }

  Future<void> updateItem(String id, {String? name, String? categoryId}) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (categoryId != null) body['category'] = categoryId;
    
    await pb.collection('wardrobe').update(id, body: body);
  }

  Future<void> deleteItem(String id) async {
    await pb.collection('wardrobe').delete(id);
    
    final box = await Hive.openBox<WardrobeItem>('wardrobe');
    await box.delete(id);
  }

  // ==================== CATEGORIES ====================

  Future<List<ItemCategory>> fetchCategories() async {
    try {
      final records = await pb.collection('categories').getFullList(
        sort: 'name',
      );
      return records.map((r) => ItemCategory.fromPocketBase(r)).toList();
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  Future<ItemCategory> addCategory(String name) async {
    final record = await pb.collection('categories').create(body: {
      'name': name,
    });
    return ItemCategory.fromPocketBase(record);
  }

  Future<void> deleteCategory(String id) async {
    await pb.collection('categories').delete(id);
  }

  // ==================== OUTFITS ====================

  Future<List<Outfit>> fetchOutfits() async {
    try {
      final userId = pb.authStore.model?.id;
      if (userId == null) return [];

      final records = await pb.collection('outfits').getFullList(
        filter: 'user = "$userId"',
        sort: '-created',
      );
      return records.map((r) => Outfit.fromPocketBase(r)).toList();
    } catch (e) {
      print('Error fetching outfits: $e');
      return [];
    }
  }

  Future<Outfit> addOutfit({
    required String name,
    required List<String> itemIds,
  }) async {
    final userId = pb.authStore.model?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final record = await pb.collection('outfits').create(body: {
      'name': name,
      'user': userId,
      'items': itemIds,
    });
    
    return Outfit.fromPocketBase(record);
  }

  Future<void> updateOutfit(String id, {String? name, List<String>? itemIds}) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (itemIds != null) body['items'] = itemIds;
    
    await pb.collection('outfits').update(id, body: body);
  }

  Future<void> deleteOutfit(String id) async {
    await pb.collection('outfits').delete(id);
  }

  // ==================== LOCAL STORAGE ====================

  Future<void> _cacheItemsLocally(List<WardrobeItem> items) async {
    final box = await Hive.openBox<WardrobeItem>('wardrobe');
    await box.clear();
    for (var item in items) {
      await box.put(item.id, item);
    }
  }

  Future<List<WardrobeItem>> _fetchItemsFromLocal() async {
    final box = await Hive.openBox<WardrobeItem>('wardrobe');
    return box.values.toList();
  }

  Future<bool> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> _saveItemLocally(WardrobeItem item) async {
    final box = await Hive.openBox<WardrobeItem>('wardrobe');
    await box.put(item.id, item);
  }
}
