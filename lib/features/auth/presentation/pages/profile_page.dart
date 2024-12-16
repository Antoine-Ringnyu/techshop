import 'package:flutter/material.dart';
import 'package:techrx/features/auth/data/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //get auth service
  final authService = AuthService();

  //logout button pressed
  void logout() async {
    await authService.signOut();
  }

  @override
  //BUILDING UI
  Widget build(BuildContext context) {
    //get user email
    final currentEmail = authService.getCurrentUserEmail();

    return SafeArea(
      child: Scaffold(
        //drawer
        drawer: const Drawer(),
      
        //appbar
        appBar: AppBar(
          //current username
          title: Text(currentEmail.toString()),
          centerTitle: true,
          actions: [
            //logout button
            IconButton(
              onPressed: logout,
              icon: const Icon(Icons.logout),
            )
          ],
        ),
      
        //BODY
        body: Container(),
      ),
    );
  }
}
