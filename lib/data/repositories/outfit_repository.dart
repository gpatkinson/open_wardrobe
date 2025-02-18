// lib/domain/repositories/outfit_repository.dart

import 'package:openwardrobe/brick/models/outfit.model.dart';
import 'package:openwardrobe/data/repositories/offline_first_repository.dart';
import 'package:openwardrobe/domain/repositories/abstract/outfit_repository.dart';

// lib/data/repositories/outfit_repository_impl.dart
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';

import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';

class OutfitRepositoryImpl implements OutfitRepository {
  final OfflineFirstWithSupabaseRepository _repository;

  OutfitRepositoryImpl() : _repository = Repository.instance;

  @override
  Future<List<Outfit>> fetchOutfits() async {
    final outfits = await _repository.get<Outfit>();
    return outfits;
  }

  @override
  Future<void> addOutfit(Outfit outfit) async {
    await _repository.upsert(Outfit(
      id: outfit.id,
      name: outfit.name,
      userProfileId: outfit.userProfileId,
    ));
  }

  @override
  Future<void> deleteOutfit(Outfit outfit) async {
    await _repository.delete<Outfit>(outfit);
  }
}
