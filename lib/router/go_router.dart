import "package:go_router/go_router.dart";
import 'package:openwardrobe/presentation/pages/auth.dart';


import "package:openwardrobe/presentation/pages/outfit.dart";



import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';



 final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (BuildContext context, GoRouterState state) {
      final session = Supabase.instance.client.auth.currentSession;
      final isLoggedIn = session != null;
      final isLoggingIn = state.location == '/auth';

      if (!isLoggedIn && !isLoggingIn) {
        return '/auth';
      } else if (isLoggedIn && isLoggingIn) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/auth',
        name: 'Auth',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/',
        name: 'Outfit',
        builder: (context, state) => const OutfitPage(),
      ),
    ],
  );
