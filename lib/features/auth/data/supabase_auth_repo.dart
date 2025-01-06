import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:techrx/features/auth/domain/entities/app_user.dart';
import 'package:techrx/features/auth/domain/repos/auth_repo.dart';

class SupabaseAuthRepo implements AuthRepo {
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      // Attempt to sign in using Supabase Auth
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      // Extract the user data if available
      final user = response.user!;

      // If the user is successfully logged in, return AppUser
      AppUser appUser = AppUser(name: '', email: email, uid: user.id);

      // Create and return the AppUser
      return appUser;
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }

  @override
  Future<AppUser?> registerWithEmailPassword(
      String name, String email, String password) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      final user = response.user!;

      final newUser = AppUser(name: name, email: email, uid: user.id);

      // Save user data in the 'users' table
      final database = Supabase.instance.client.from('users');
      await database.insert(newUser.toMap());

      // Create and return the AppUser
      return newUser;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    await supabase.auth.signOut();
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    // Get the current user from Supabase
    final User? user = supabase.auth.currentUser;

    // No user is logged in
    if (user == null) {
      return null;
    }

    // Fetch user data from the 'users' table
    final response = await supabase
        .from('users')
        .select('name, email')
        .eq('uid', user.id)
        .single();

    //current app user
    AppUser currentAppUser = AppUser(
      name: response['name'],
      email: response['email'],
      // email: response.entries.first.value,
      uid: user.id,
    );

    // Return the user
    return currentAppUser;
  }
}
