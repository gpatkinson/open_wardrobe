import 'package:hive/hive.dart';
import 'package:pocketbase/pocketbase.dart';

part 'wardrobe_item.g.dart'; 

@HiveType(typeId: 0)
class WardrobeItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String? brandId;

  @HiveField(4)
  final String? categoryId;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final DateTime updatedAt;

  @HiveField(7)
  bool isSynced;

  WardrobeItem({
    required this.id,
    required this.userId,
    required this.name,
    this.brandId,
    this.categoryId,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = true,
  });

  // From PocketBase record
  factory WardrobeItem.fromPocketBase(RecordModel record) {
    return WardrobeItem(
      id: record.id,
      userId: record.getStringValue('user'),
      name: record.getStringValue('name'),
      brandId: record.getStringValue('brand').isEmpty ? null : record.getStringValue('brand'),
      categoryId: record.getStringValue('category').isEmpty ? null : record.getStringValue('category'),
      createdAt: DateTime.parse(record.created),
      updatedAt: DateTime.parse(record.updated),
      isSynced: true,
    );
  }

  // From JSON (for local storage compatibility)
  factory WardrobeItem.fromJson(Map<String, dynamic> json) {
    return WardrobeItem(
      id: json['id'],
      userId: json['user'] ?? json['user_id'] ?? '',
      name: json['name'],
      brandId: json['brand'] ?? json['brand_id'],
      categoryId: json['category'] ?? json['category_id'],
      createdAt: DateTime.parse(json['created'] ?? json['created_at']),
      updatedAt: DateTime.parse(json['updated'] ?? json['updated_at']),
      isSynced: json['is_synced'] ?? true,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'user': userId,
    'name': name,
    'brand': brandId,
    'category': categoryId,
    'created': createdAt.toIso8601String(),
    'updated': updatedAt.toIso8601String(),
    'is_synced': isSynced,
  };
}
