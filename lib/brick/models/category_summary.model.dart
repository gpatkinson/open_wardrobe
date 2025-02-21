import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'v_user_category_summary'),
  sqliteConfig: SqliteSerializable(),
)
class CategorySummary extends OfflineFirstWithSupabaseModel {
  @Supabase()
  final String categoryId;

  @Supabase()
  final String categoryName;

  @Supabase()
  final int itemCount;

  @Supabase()
  final String? categoryImage;


  CategorySummary({
    required this.categoryId,
    required this.categoryName,
    required this.itemCount,
    this.categoryImage,
  });
}