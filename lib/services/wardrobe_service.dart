import '../repositories/wardrobe_repository.dart';
import '../models/wardrobe_item.dart';
import '../models/item_category.dart';
import '../models/outfit.dart';

class WardrobeService {
  final WardrobeRepository _repository;

  WardrobeService(this._repository);

  // Wardrobe Items
  Future<List<WardrobeItem>> getWardrobeItems() => _repository.fetchItems();
  
  Future<WardrobeItem> addWardrobeItem({
    required String name,
    String? categoryId,
    List<int>? imageBytes,
    String? imageName,
  }) => _repository.addItem(
    name: name,
    categoryId: categoryId,
    imageBytes: imageBytes,
    imageName: imageName,
  );
  
  Future<void> updateWardrobeItem(String id, {String? name, String? categoryId}) => 
    _repository.updateItem(id, name: name, categoryId: categoryId);
  
  Future<void> deleteWardrobeItem(String id) => _repository.deleteItem(id);

  // Categories
  Future<List<ItemCategory>> getCategories() => _repository.fetchCategories();
  Future<ItemCategory> addCategory(String name) => _repository.addCategory(name);
  Future<void> updateCategory(String id, String name) => _repository.updateCategory(id, name);
  Future<void> deleteCategory(String id) => _repository.deleteCategory(id);

  // Outfits
  Future<List<Outfit>> getOutfits() => _repository.fetchOutfits();
  
  Future<Outfit> createOutfit({
    required String name,
    required List<String> itemIds,
  }) => _repository.addOutfit(name: name, itemIds: itemIds);
  
  Future<void> updateOutfit(String id, {String? name, List<String>? itemIds}) =>
    _repository.updateOutfit(id, name: name, itemIds: itemIds);
  
  Future<void> deleteOutfit(String id) => _repository.deleteOutfit(id);
}
