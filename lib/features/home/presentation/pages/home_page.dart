import 'package:flutter/material.dart';
import 'package:techrx/features/auth/data/auth_service.dart';
import 'package:techrx/features/home/presentation/components/my_drawer.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
   //get auth service
  final authService = AuthService();

  //logout button pressed
  void logout() async {
    await authService.signOut();
  }
  

  //BUILD UI
  @override
  Widget build(BuildContext context) {
    //get user email
    final currentEmail = authService.getCurrentUserEmail();

    //SCAFFOLD
    return Scaffold(
        //APP BAR
        appBar: AppBar(
          centerTitle: true,
          title: Text(currentEmail.toString()),
          foregroundColor: Theme.of(context).colorScheme.primary,
          actions: [
            //upload new post button
            IconButton(
                onPressed: logout,
                icon: const Icon(Icons.logout_rounded)),
          ],
        ),

        //DRAWER
        drawer: MyDrawer(),

        //BODY
        body: Container(),
    );
        
  }
}
