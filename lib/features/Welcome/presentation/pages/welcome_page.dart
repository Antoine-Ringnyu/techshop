import 'package:flutter/material.dart';
import 'package:techrx/features/auth/presentation/pages/auth_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  //BUILDING UI
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //drawer
        drawer: const Drawer(),

        //appbar
        appBar: AppBar(
          //current username
          title: const Text("TechRx"),
          centerTitle: true,
          actions: [
            //logout button
            IconButton(
                onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AuthPage(),
                      ),
                    ),
                icon: const Icon(Icons.person)),
          ],
        ),

        //BODY
        body: Container(),
      ),
    );
  }
}
