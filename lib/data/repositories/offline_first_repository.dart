// lib/src/brick/repository.dart
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_sqlite/memory_cache_provider.dart';
import 'package:brick_supabase/brick_supabase.dart' hide Supabase;
import 'package:openwardrobe/brick/brick.g.dart';
import 'package:openwardrobe/brick/db/schema.g.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:supabase_flutter/supabase_flutter.dart';



class Repository extends OfflineFirstWithSupabaseRepository {
  static Repository? _instance;

  Repository._({
    required super.supabaseProvider,
    required super.sqliteProvider,
    required super.migrations,
    required super.offlineRequestQueue,
    super.memoryCacheProvider,
  });

  /// Configure and initialize the Singleton Repository
  static Future<void> configure(DatabaseFactory databaseFactory) async {
    if (_instance != null) return; // Prevent re-initialization

    final (client, queue) = OfflineFirstWithSupabaseRepository.clientQueue(
      databaseFactory: databaseFactory,
    );

    await Supabase.initialize(
      url: "https://openwdsupdemo.sug.lol",
      anonKey: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJzdXBhYmFzZSIsImlhdCI6MTczODg5ODA0MCwiZXhwIjo0ODk0NTcxNjQwLCJyb2xlIjoiYW5vbiJ9.bv0LuM7PP9JxKSrI7XTzw_I2IS7-86L8iqIkHiN-aQI",
      debug: true,
      httpClient: client,
    );

    final provider = SupabaseProvider(
      Supabase.instance.client,
      modelDictionary: supabaseModelDictionary,
    );

    _instance = Repository._(
      supabaseProvider: provider,
      sqliteProvider: SqliteProvider(
        'my_repository.sqlite',
        databaseFactory: databaseFactory,
        modelDictionary: sqliteModelDictionary,
      ),
      migrations: migrations,
      offlineRequestQueue: queue,
      // Specify class types that should be cached in memory
      memoryCacheProvider: MemoryCacheProvider(),
    );
  }

  /// Get the Singleton instance
  static Repository get instance {
    if (_instance == null) {
      throw Exception("Repository must be configured before use. Call Repository.configure() first.");
    }
    return _instance!;
  }
}