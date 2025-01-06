import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techrx/features/auth/presentation/components/my_button.dart';
import 'package:techrx/features/auth/presentation/components/my_text_field.dart';
import 'package:techrx/features/auth/presentation/cubits/auth_cubit.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? togglePages;
  const RegisterPage({
    super.key,
    this.togglePages,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  //auth cubit

  //text controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  //login button pressed
  void signUp() async {
    //prepare  data
    final name = _nameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    final authCubit = context.read<AuthCubit>();

    //ensure the fields aren't empty
    if (email.isNotEmpty &&
        name.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty) {
      //ensure passwords match
      if (password == confirmPassword) {
        authCubit.register(name, email, password);
      }

      //password don't match
      else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      }
    }

    //fields are empty -> display error
    else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please complete all fields')));
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
                "Lets create an account for you",
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
                  controller: _nameController,
                  hintText: 'Name',
                  obscureText: false),

              const SizedBox(
                height: 10,
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
                height: 10,
              ),

              //password textfield
              MyTextField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm password',
                  obscureText: true),

              const SizedBox(
                height: 25,
              ),

              //login button
              MyButton(
                onTab: signUp,
                text: 'Register',
              ),

              const SizedBox(
                height: 50,
              ),

              //not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already a member? ',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.togglePages,
                    child: Text(
                      ' Login now.',
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
