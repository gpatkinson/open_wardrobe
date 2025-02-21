// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<CategorySummary> _$CategorySummaryFromSupabase(Map<String, dynamic> data,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return CategorySummary(
      categoryId: data['category_id'] as String,
      categoryName: data['category_name'] as String,
      itemCount: data['item_count'] as int,
      categoryImage: data['category_image'] == null
          ? null
          : data['category_image'] as String?);
}

Future<Map<String, dynamic>> _$CategorySummaryToSupabase(
    CategorySummary instance,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'category_id': instance.categoryId,
    'category_name': instance.categoryName,
    'item_count': instance.itemCount,
    'category_image': instance.categoryImage
  };
}

Future<CategorySummary> _$CategorySummaryFromSqlite(Map<String, dynamic> data,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return CategorySummary(
      categoryId: data['category_id'] as String,
      categoryName: data['category_name'] as String,
      itemCount: data['item_count'] as int,
      categoryImage: data['category_image'] == null
          ? null
          : data['category_image'] as String?)
    ..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$CategorySummaryToSqlite(CategorySummary instance,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'category_id': instance.categoryId,
    'category_name': instance.categoryName,
    'item_count': instance.itemCount,
    'category_image': instance.categoryImage
  };
}

/// Construct a [CategorySummary]
class CategorySummaryAdapter
    extends OfflineFirstWithSupabaseAdapter<CategorySummary> {
  CategorySummaryAdapter();

  @override
  final supabaseTableName = 'v_user_category_summary';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'categoryId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'category_id',
    ),
    'categoryName': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'category_name',
    ),
    'itemCount': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'item_count',
    ),
    'categoryImage': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'category_image',
    )
  };
  @override
  final ignoreDuplicates = false;
  @override
  final uniqueFields = {};
  @override
  final Map<String, RuntimeSqliteColumnDefinition> fieldsToSqliteColumns = {
    'primaryKey': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: '_brick_id',
      iterable: false,
      type: int,
    ),
    'categoryId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'category_id',
      iterable: false,
      type: String,
    ),
    'categoryName': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'category_name',
      iterable: false,
      type: String,
    ),
    'itemCount': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'item_count',
      iterable: false,
      type: int,
    ),
    'categoryImage': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'category_image',
      iterable: false,
      type: String,
    )
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
          CategorySummary instance, DatabaseExecutor executor) async =>
      instance.primaryKey;
  @override
  final String tableName = 'CategorySummary';

  @override
  Future<CategorySummary> fromSupabase(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$CategorySummaryFromSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSupabase(CategorySummary input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$CategorySummaryToSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<CategorySummary> fromSqlite(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$CategorySummaryFromSqlite(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(CategorySummary input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$CategorySummaryToSqlite(input,
          provider: provider, repository: repository);
}
