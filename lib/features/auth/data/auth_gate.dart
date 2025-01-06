/* 
AUTH GATE - this will continously listen to for auth state changes

--------------------------------------------------------------------------

authenticated -> login
unauthenticated -> profile page

*/


import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:techrx/features/Welcome/presentation/pages/welcome_page.dart';
import 'package:techrx/features/profile/presentation/pages/profile_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      //listen to auth state changes
      stream: Supabase.instance.client.auth.onAuthStateChange,

      //builds appropriate pages base on the auth state
      builder: (context, snapshot) {
        //loading .........
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        //check if the  is a valid session currently
        final session = snapshot.hasData ? snapshot.data!.session : null;

        if (session != null) {
          return const ProfilePage();
        } else {
          return const WelcomePage();
        }
      });
  }
}
