// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<WardrobeItem> _$WardrobeItemFromSupabase(Map<String, dynamic> data,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return WardrobeItem(
      id: data['id'] as String?,
      userProfileId: data['user_profile_id'] as String,
      brand: data['brand_id'] == null
          ? null
          : await BrandAdapter().fromSupabase(data['brand_id'],
              provider: provider, repository: repository),
      category: data['category_id'] == null
          ? null
          : await CategoryAdapter().fromSupabase(data['category_id'],
              provider: provider, repository: repository),
      createdAt: data['created_at'] == null
          ? null
          : data['created_at'] == null
              ? null
              : DateTime.tryParse(data['created_at'] as String),
      updatedAt: data['updated_at'] == null
          ? null
          : data['updated_at'] == null
              ? null
              : DateTime.tryParse(data['updated_at'] as String),
      deletedAt: data['deleted_at'] == null
          ? null
          : data['deleted_at'] == null
              ? null
              : DateTime.tryParse(data['deleted_at'] as String),
      imagePath:
          data['image_path'] == null ? null : data['image_path'] as String?);
}

Future<Map<String, dynamic>> _$WardrobeItemToSupabase(WardrobeItem instance,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'user_profile_id': instance.userProfileId,
    'brand_id': instance.brand != null
        ? await BrandAdapter().toSupabase(instance.brand!,
            provider: provider, repository: repository)
        : null,
    'category_id': instance.category != null
        ? await CategoryAdapter().toSupabase(instance.category!,
            provider: provider, repository: repository)
        : null,
    'created_at': instance.createdAt?.toIso8601String(),
    'updated_at': instance.updatedAt?.toIso8601String(),
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'image_path': instance.imagePath
  };
}

Future<WardrobeItem> _$WardrobeItemFromSqlite(Map<String, dynamic> data,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return WardrobeItem(
      id: data['id'] as String,
      userProfileId: data['user_profile_id'] as String,
      brand: data['brand_Brand_brick_id'] == null
          ? null
          : (data['brand_Brand_brick_id'] > -1
              ? (await repository?.getAssociation<Brand>(
                  Query.where('primaryKey', data['brand_Brand_brick_id'] as int,
                      limit1: true),
                ))
                  ?.first
              : null),
      category: data['category_Category_brick_id'] == null
          ? null
          : (data['category_Category_brick_id'] > -1
              ? (await repository?.getAssociation<Category>(
                  Query.where(
                      'primaryKey', data['category_Category_brick_id'] as int,
                      limit1: true),
                ))
                  ?.first
              : null),
      createdAt: data['created_at'] == null
          ? null
          : data['created_at'] == null
              ? null
              : DateTime.tryParse(data['created_at'] as String),
      updatedAt: data['updated_at'] == null
          ? null
          : data['updated_at'] == null
              ? null
              : DateTime.tryParse(data['updated_at'] as String),
      deletedAt: data['deleted_at'] == null
          ? null
          : data['deleted_at'] == null
              ? null
              : DateTime.tryParse(data['deleted_at'] as String),
      imagePath:
          data['image_path'] == null ? null : data['image_path'] as String?)
    ..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$WardrobeItemToSqlite(WardrobeItem instance,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'user_profile_id': instance.userProfileId,
    'brand_Brand_brick_id': instance.brand != null
        ? instance.brand!.primaryKey ??
            await provider.upsert<Brand>(instance.brand!,
                repository: repository)
        : null,
    'category_Category_brick_id': instance.category != null
        ? instance.category!.primaryKey ??
            await provider.upsert<Category>(instance.category!,
                repository: repository)
        : null,
    'created_at': instance.createdAt?.toIso8601String(),
    'updated_at': instance.updatedAt?.toIso8601String(),
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'image_path': instance.imagePath
  };
}

/// Construct a [WardrobeItem]
class WardrobeItemAdapter
    extends OfflineFirstWithSupabaseAdapter<WardrobeItem> {
  WardrobeItemAdapter();

  @override
  final supabaseTableName = 'wardrobe_item';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'userProfileId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'user_profile_id',
    ),
    'brand': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'brand_id',
      associationType: Brand,
      associationIsNullable: true,
    ),
    'category': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'category_id',
      associationType: Category,
      associationIsNullable: true,
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
    ),
    'updatedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'updated_at',
    ),
    'deletedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'deleted_at',
    ),
    'imagePath': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'image_path',
    )
  };
  @override
  final ignoreDuplicates = false;
  @override
  final uniqueFields = {'id'};
  @override
  final Map<String, RuntimeSqliteColumnDefinition> fieldsToSqliteColumns = {
    'primaryKey': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: '_brick_id',
      iterable: false,
      type: int,
    ),
    'id': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'id',
      iterable: false,
      type: String,
    ),
    'userProfileId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'user_profile_id',
      iterable: false,
      type: String,
    ),
    'brand': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'brand_Brand_brick_id',
      iterable: false,
      type: Brand,
    ),
    'category': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'category_Category_brick_id',
      iterable: false,
      type: Category,
    ),
    'createdAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'created_at',
      iterable: false,
      type: DateTime,
    ),
    'updatedAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'updated_at',
      iterable: false,
      type: DateTime,
    ),
    'deletedAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'deleted_at',
      iterable: false,
      type: DateTime,
    ),
    'imagePath': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'image_path',
      iterable: false,
      type: String,
    )
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
      WardrobeItem instance, DatabaseExecutor executor) async {
    final results = await executor.rawQuery('''
        SELECT * FROM `WardrobeItem` WHERE id = ? LIMIT 1''', [instance.id]);

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'WardrobeItem';

  @override
  Future<WardrobeItem> fromSupabase(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$WardrobeItemFromSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSupabase(WardrobeItem input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$WardrobeItemToSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<WardrobeItem> fromSqlite(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$WardrobeItemFromSqlite(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(WardrobeItem input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$WardrobeItemToSqlite(input,
          provider: provider, repository: repository);
}
