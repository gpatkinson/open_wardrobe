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
  final String? categoryId;

  @HiveField(4)
  final String? imageUrl;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final DateTime updatedAt;

  @HiveField(7)
  bool isSynced;

  // Not stored in Hive, populated when fetching
  String? categoryName;

  WardrobeItem({
    required this.id,
    required this.userId,
    required this.name,
    this.categoryId,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = true,
    this.categoryName,
  });

  factory WardrobeItem.fromPocketBase(RecordModel record, {String? baseUrl}) {
    String? imageUrl;
    final imageFile = record.getStringValue('image');
    if (imageFile.isNotEmpty && baseUrl != null) {
      imageUrl = '$baseUrl/api/files/${record.collectionId}/${record.id}/$imageFile';
    }

    return WardrobeItem(
      id: record.id,
      userId: record.getStringValue('user'),
      name: record.getStringValue('name'),
      categoryId: record.getStringValue('category').isEmpty ? null : record.getStringValue('category'),
      imageUrl: imageUrl,
      createdAt: DateTime.parse(record.created),
      updatedAt: DateTime.parse(record.updated),
      isSynced: true,
    );
  }

  factory WardrobeItem.fromJson(Map<String, dynamic> json) {
    return WardrobeItem(
      id: json['id'],
      userId: json['user'] ?? json['user_id'] ?? '',
      name: json['name'],
      categoryId: json['category'] ?? json['category_id'],
      imageUrl: json['image_url'],
      createdAt: DateTime.parse(json['created'] ?? json['created_at']),
      updatedAt: DateTime.parse(json['updated'] ?? json['updated_at']),
      isSynced: json['is_synced'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user': userId,
    'name': name,
    'category': categoryId,
    'image_url': imageUrl,
    'created': createdAt.toIso8601String(),
    'updated': updatedAt.toIso8601String(),
    'is_synced': isSynced,
  };

  WardrobeItem copyWith({
    String? id,
    String? userId,
    String? name,
    String? categoryId,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
    String? categoryName,
  }) {
    return WardrobeItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      categoryName: categoryName ?? this.categoryName,
    );
  }
}
