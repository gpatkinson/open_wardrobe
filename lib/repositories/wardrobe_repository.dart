import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:pocketbase/pocketbase.dart';

import '../main.dart';
import '../models/wardrobe_item.dart';

class WardrobeRepository {
  // Fetch items from PocketBase or from local storage if offline
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
        
        final items = records.map((record) => WardrobeItem.fromPocketBase(record)).toList();
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

  // Add a new item
  Future<WardrobeItem> addItem({
    required String name,
    String? brandId,
    String? categoryId,
  }) async {
    final isOnline = await _checkConnectivity();
    final userId = pb.authStore.model?.id;
    
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    if (isOnline) {
      final record = await pb.collection('wardrobe').create(body: {
        'name': name,
        'user': userId,
        'brand': brandId,
        'category': categoryId,
      });
      
      final item = WardrobeItem.fromPocketBase(record);
      await _saveItemLocally(item);
      return item;
    } else {
      // Create local item to sync later
      final item = WardrobeItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        name: name,
        brandId: brandId,
        categoryId: categoryId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isSynced: false,
      );
      await _saveItemLocally(item);
      return item;
    }
  }

  // Delete an item
  Future<void> deleteItem(String id) async {
    final isOnline = await _checkConnectivity();
    
    if (isOnline) {
      await pb.collection('wardrobe').delete(id);
    }
    
    final box = await Hive.openBox<WardrobeItem>('wardrobe');
    await box.delete(id);
  }

  // Sync local changes with PocketBase
  Future<void> syncLocalChanges() async {
    final box = await Hive.openBox<WardrobeItem>('wardrobe');
    final unsyncedItems = box.values.where((item) => !item.isSynced).toList();

    for (var item in unsyncedItems) {
      try {
        await pb.collection('wardrobe').create(body: {
          'name': item.name,
          'user': item.userId,
          'brand': item.brandId,
          'category': item.categoryId,
        });
        item.isSynced = true;
        await item.save();
      } catch (e) {
        print('Failed to sync item ${item.id}: $e');
      }
    }
  }

  // Cache items locally with Hive
  Future<void> _cacheItemsLocally(List<WardrobeItem> items) async {
    final box = await Hive.openBox<WardrobeItem>('wardrobe');
    await box.clear();
    for (var item in items) {
      await box.put(item.id, item);
    }
  }

  // Fetch items from local Hive storage
  Future<List<WardrobeItem>> _fetchItemsFromLocal() async {
    final box = await Hive.openBox<WardrobeItem>('wardrobe');
    return box.values.toList();
  }

  // Check network connectivity
  Future<bool> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // Save item locally
  Future<void> _saveItemLocally(WardrobeItem item) async {
    final box = await Hive.openBox<WardrobeItem>('wardrobe');
    await box.put(item.id, item);
  }
}
