import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'router/app_router.dart';

import 'models/wardrobe_item.dart';
import 'models/outfit.dart';
import 'models/brand.dart';
import 'models/item_category.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  // Use .env.local for local development, .env for production
  await dotenv.load(fileName: kReleaseMode ? '.env' : '.env.local');

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Initialize Supabase from environment variables
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    debug: !kReleaseMode,
  );


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
        useMaterial3: true,  // Enable Material 3 (modern UI)
      ),
      darkTheme: ThemeData.dark(),  // Support dark mode
      themeMode: ThemeMode.system,  // Automatically switch theme

      routerConfig: AppRouter.router,
    );
  }
}
