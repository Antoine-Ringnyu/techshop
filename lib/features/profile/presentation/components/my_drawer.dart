import 'package:flutter/material.dart';
import 'package:techrx/features/auth/data/supabase_auth_repo.dart';
import 'package:techrx/features/profile/presentation/components/my_drawer_tile.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  //get auth service
  final supabaseAuthRepo = SupabaseAuthRepo();

  //logout button pressed
  void logout() async {
    await supabaseAuthRepo.logout();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),

              //logo
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: Icon(
                  Icons.person_outlined,
                  size: 80,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),

              //divider
              Divider(
                color: Theme.of(context).colorScheme.secondary,
              ),

              //home tile
              MyDrawerTile(
                title: 'H O M E',
                icon: Icons.home,
                onTap: () => Navigator.of(context).pop(),
              ),

              //profile tile
              MyDrawerTile(
                title: 'P R O F I L E',
                icon: Icons.person,
                onTap: () {
                  //just poping the drawer menu
                  Navigator.of(context).pop();

                  //get the current user id

                  //navigate to the profile page
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => ProfilePage(
                  //       uid: uid,
                  //     ),
                  //   ),
                  // );
                },
              ),

              //search tile
              MyDrawerTile(
                  title: 'S E A R C H',
                  icon: Icons.search,
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const SearchPage(),
                    //   ),
                    // );
                    // //just poping the drawer menu
                    // Navigator.of(context).pop();
                  }),

              //setting tile
              MyDrawerTile(
                title: 'S E T T I N G S',
                icon: Icons.settings,
                onTap: () {
                  //just poping the drawer menu
                  Navigator.of(context).pop();
                },
              ),

              //SPACER
              const Spacer(),

              //logout tile
              MyDrawerTile(
                title: 'L O G O U T',
                icon: Icons.logout,
                onTap: logout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
