import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../main.dart';
import '../ui/screens/home_page.dart';
import '../ui/screens/auth_page.dart';  
import '../ui/widgets/tab_scaffold.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/home',
    
    // Handle redirection based on auth status
    redirect: (BuildContext context, GoRouterState state) {
      final isLoggedIn = pb.authStore.isValid;
      final isLoggingIn = state.uri.toString() == '/auth';

      if (!isLoggedIn && !isLoggingIn) {
        return '/auth';  // Redirect unauthenticated users to login
      } else if (isLoggedIn && isLoggingIn) {
        return '/home';  // Redirect logged-in users away from login
      }

      return null;  // No redirection needed
    },

    routes: [
      // Login Route (accessible without authentication)
      GoRoute(
        path: '/auth',
        name: 'Auth',
        pageBuilder: (context, state) => const NoTransitionPage(child: AuthScreen()),
      ),

      // Protected Routes (require authentication)
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
        ],
      ),
    ],
  );
}
