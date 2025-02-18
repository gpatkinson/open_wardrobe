// lib/domain/repositories/outfit_repository.dart

abstract class OutfitRepository {
  Future<List<Outfit>> fetchOutfits();
}