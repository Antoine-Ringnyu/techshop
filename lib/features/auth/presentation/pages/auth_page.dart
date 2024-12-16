/*

Auth page - this page determines whether to show the login or register page

*/

import 'package:flutter/widgets.dart';
import 'package:techrx/features/auth/presentation/pages/log_in_page.dart';
import 'package:techrx/features/auth/presentation/pages/register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPagesState();
}

class _AuthPagesState extends State<AuthPage> {
  //initially, show login page
  bool showLoginPage = true;

  //toggle between pages
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LogInPage(
        togglePages: togglePages,
      );
    } else {
      return RegisterPage(
        togglePages: togglePages,
      );
    }
  }
}
