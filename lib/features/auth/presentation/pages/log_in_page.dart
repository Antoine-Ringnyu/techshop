import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:techrx/features/auth/data/auth_service.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  //get auth service
  final authService = AuthService();

  //text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  //login button pressed
  void login() async {
    //prepare  data
    final email = _emailController.text;
    final password = _passwordController.text;

    //attempt to login
    try{
      await authService.signInWithEmailPassword(email, password);
    } catch(e){}
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
