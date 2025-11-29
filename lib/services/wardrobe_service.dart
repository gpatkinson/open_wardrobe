import '../repositories/wardrobe_repository.dart';
import '../models/wardrobe_item.dart';

class WardrobeService {
  final WardrobeRepository wardrobeRepository;

  WardrobeService(this.wardrobeRepository);

  Future<List<WardrobeItem>> getWardrobeItems() async {
    return await wardrobeRepository.fetchItems();
  }

  Future<WardrobeItem> addWardrobeItem({
    required String name,
    String? brandId,
    String? categoryId,
  }) async {
    return await wardrobeRepository.addItem(
      name: name,
      brandId: brandId,
      categoryId: categoryId,
    );
  }

  Future<void> deleteWardrobeItem(String id) async {
    await wardrobeRepository.deleteItem(id);
  }

  Future<void> syncWardrobe() async {
    await wardrobeRepository.syncLocalChanges();
  }
}
