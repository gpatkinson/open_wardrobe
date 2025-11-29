import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../main.dart';
import '../ui/screens/home_page.dart';
import '../ui/screens/auth_page.dart';
import '../ui/screens/wardrobe.dart';
import '../ui/screens/outfits_page.dart';
import '../ui/widgets/tab_scaffold.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/home',
    
    redirect: (BuildContext context, GoRouterState state) {
      final isLoggedIn = pb.authStore.isValid;
      final isLoggingIn = state.uri.toString() == '/auth';

      if (!isLoggedIn && !isLoggingIn) {
        return '/auth';
      } else if (isLoggedIn && isLoggingIn) {
        return '/home';
      }

      return null;
    },

    routes: [
      GoRoute(
        path: '/auth',
        name: 'Auth',
        pageBuilder: (context, state) => const NoTransitionPage(child: AuthScreen()),
      ),

      ShellRoute(
        builder: (context, state, child) {
          return TabScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            name: 'Home',
            pageBuilder: (context, state) => const NoTransitionPage(child: HomeScreen()),
          ),
          GoRoute(
            path: '/wardrobe',
            name: 'Wardrobe',
            pageBuilder: (context, state) => const NoTransitionPage(child: WardrobeScreen()),
          ),
          GoRoute(
            path: '/outfits',
            name: 'Outfits',
            pageBuilder: (context, state) => const NoTransitionPage(child: OutfitsScreen()),
          ),
        ],
      ),
    ],
  );
}
