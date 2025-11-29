import 'package:hive/hive.dart';
import 'package:pocketbase/pocketbase.dart';

part 'outfit.g.dart';

@HiveType(typeId: 1)
class Outfit extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final DateTime updatedAt;

  @HiveField(5)
  List<String> itemIds;

  @HiveField(6)
  bool isSynced;

  Outfit({
    required this.id,
    required this.userId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.itemIds = const [],
    this.isSynced = true,
  });

  factory Outfit.fromPocketBase(RecordModel record) {
    return Outfit(
      id: record.id,
      userId: record.getStringValue('user'),
      name: record.getStringValue('name'),
      createdAt: DateTime.parse(record.created),
      updatedAt: DateTime.parse(record.updated),
      itemIds: List<String>.from(record.getListValue<String>('items')),
      isSynced: true,
    );
  }

  factory Outfit.fromJson(Map<String, dynamic> json) {
    return Outfit(
      id: json['id'],
      userId: json['user'] ?? json['user_id'] ?? '',
      name: json['name'],
      createdAt: DateTime.parse(json['created'] ?? json['created_at']),
      updatedAt: DateTime.parse(json['updated'] ?? json['updated_at']),
      itemIds: List<String>.from(json['items'] ?? json['wardrobe_item_ids'] ?? []),
      isSynced: json['is_synced'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user': userId,
    'name': name,
    'items': itemIds,
    'created': createdAt.toIso8601String(),
    'updated': updatedAt.toIso8601String(),
    'is_synced': isSynced,
  };
}
