import 'package:hive/hive.dart';
import 'package:pocketbase/pocketbase.dart';

part 'item_category.g.dart';

@HiveType(typeId: 3)
class ItemCategory extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? icon;

  ItemCategory({
    required this.id, 
    required this.name,
    this.icon,
  });

  factory ItemCategory.fromPocketBase(RecordModel record) {
    return ItemCategory(
      id: record.id,
      name: record.getStringValue('name'),
      icon: record.getStringValue('icon').isEmpty ? null : record.getStringValue('icon'),
    );
  }

  factory ItemCategory.fromJson(Map<String, dynamic> json) {
    return ItemCategory(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'icon': icon,
  };
}
