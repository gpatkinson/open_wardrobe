import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  /// Get the currently authenticated user's ID
  static String? getUserId() {
    // Print
    print('Fetching user ID...');
    final user = Supabase.instance.client.auth.currentUser;
    return user?.id;
  }

  /// Check if the user is authenticated
  static bool isUserLoggedIn() {
    return Supabase.instance.client.auth.currentUser != null;
  }
}