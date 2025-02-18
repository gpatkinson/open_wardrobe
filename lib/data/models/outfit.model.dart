// lib/data/models/outfit.model.dart
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'outfit'),
)
class Outfit extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  final String userProfileId;

  final String name;

  @Supabase(name: 'created_at')
  final DateTime? createdAt;

  @Supabase(name: 'updated_at')
  final DateTime? updatedAt;

  @Supabase(name: 'deleted_at')
  final DateTime? deletedAt;

  Outfit({
    String? id,
    required this.userProfileId,
    required this.name,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  }) : this.id = id ?? const Uuid().v4();
}