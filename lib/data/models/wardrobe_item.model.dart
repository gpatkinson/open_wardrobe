// lib/data/models/wardrobe_item.model.dart
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';
import 'brand.model.dart';
import 'category.model.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'wardrobe_item'),
)
class WardrobeItem extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  final String userProfileId;

  @Supabase(name: 'brand_id')
  final Brand? brand;

  @Supabase(name: 'category_id')
  final Category? category;

  @Supabase(name: 'created_at')
  final DateTime? createdAt;

  @Supabase(name: 'updated_at')
  final DateTime? updatedAt;

  @Supabase(name: 'deleted_at')
  final DateTime? deletedAt;

  @Supabase(name: 'image_path')
  final String? imagePath;

  WardrobeItem({
    String? id,
    required this.userProfileId,
    this.brand,
    this.category,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.imagePath,
  }) : this.id = id ?? const Uuid().v4();
}