import 'package:flutter/material.dart';
import 'package:techrx/features/auth/data/supabase_auth_repo.dart';
import 'package:techrx/features/auth/presentation/components/my_button.dart';
import 'package:techrx/features/auth/presentation/components/my_text_field.dart';

class LogInPage extends StatefulWidget {
  final void Function()? togglePages;
  const LogInPage({super.key, this.togglePages});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  //get auth service
  final supabaseAuthRepo = SupabaseAuthRepo();

  //text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  //login button pressed
  void login() async {
    //prepare  data
    final email = _emailController.text;
    final password = _passwordController.text;

    //attempt to login
    try {
      await supabaseAuthRepo.loginWithEmailPassword(email, password);
      //pop this register page
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error : $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //appbar
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          // title: Text(
          //     'Login',
          //     textAlign: TextAlign.center,
          //     style: TextStyle(
          //       fontSize: 24,
          //       color: Theme.of(context).colorScheme.primary,
          //     ),
          //   ),
        ),

        //BODY
        body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
            children: [
              //logo
              Icon(
                Icons.lock_open_rounded,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),

              const SizedBox(
                height: 50,
              ),

              //welcome back message
              Text(
                "Welcome back, you've been missed!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 16,
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              //email textfield
              MyTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  obscureText: false),

              const SizedBox(
                height: 10,
              ),

              //password textfield
              MyTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: true),

              const SizedBox(
                height: 25,
              ),

              //login button
              MyButton(
                onTab: login,
                text: 'Login',
              ),

              const SizedBox(
                height: 50,
              ),

              //not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not a member? ',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.togglePages,
                    child: Text(
                      ' Register now.',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ]),
      ),
    );
  }
}
