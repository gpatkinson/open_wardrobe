import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pocketbase/pocketbase.dart';
import 'router/app_router.dart';

import 'models/wardrobe_item.dart';
import 'models/outfit.dart';
import 'models/brand.dart';
import 'models/item_category.dart';

// Global PocketBase instance
late final PocketBase pb;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: kReleaseMode ? '.env' : '.env.local');

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Initialize PocketBase
  pb = PocketBase(dotenv.env['POCKETBASE_URL'] ?? 'http://127.0.0.1:8090');

  // Register Hive adapters
  Hive.registerAdapter(WardrobeItemAdapter());
  Hive.registerAdapter(OutfitAdapter());
  Hive.registerAdapter(BrandAdapter());
  Hive.registerAdapter(ItemCategoryAdapter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'OpenWardrobe',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
    );
  }
}
