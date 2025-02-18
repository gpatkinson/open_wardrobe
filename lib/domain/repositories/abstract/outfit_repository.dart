// lib/domain/repositories/outfit_repository.dart

import 'package:openwardrobe/brick/models/outfit.model.dart';


abstract class OutfitRepository {
  Future<List<Outfit>> fetchOutfits();
  Future<void> addOutfit(Outfit outfit);
}