import 'package:flutter/material.dart';
import 'package:techrx/features/Welcome/presentation/components/sample_tickets.dart';
import 'package:techrx/features/auth/presentation/pages/auth_page.dart';
import 'package:techrx/features/profile/presentation/components/my_drawer.dart';
import 'package:techrx/features/searchTickets/presentation/components/search_tickets.dart';
import 'package:techrx/features/ticket/presentation/pages/create_ticket.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // AppBar
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,

          // App logo
          title: Text(
            'T e c h R x',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          centerTitle: true,
          actions: [
            // Logout button
            IconButton(
              color: Theme.of(context).colorScheme.inversePrimary,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AuthPage(),
                ),
              ),
              icon: const Icon(Icons.person_outlined),
              iconSize: 32,
            ),
          ],
        ),

        // Drawer
        drawer: MyDrawer(),

        // Body content
        body: Stack(
          children: [
            ListView(
              children: [
                // Search and Create Ticket
                Container(
                  padding: const EdgeInsets.fromLTRB(30, 120, 30, 50),
                  color: Theme.of(context).colorScheme.inversePrimary,
                  child: const CreateTicket(),
                ),

                // Sample Tickets
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 30),
                  child: SampleTickets(),
                ),
                // Container(
                //   padding: const EdgeInsets.all(50),
                //   color: Theme.of(context).colorScheme.secondary,
                // ),
              ],
            ),

            // The floating dropdown from SearchTickets will be positioned above the other content
            const Positioned(
              top:
                  20, // You can adjust this value to control where the dropdown appears
              left: 30,
              right: 30,
              child: SearchTickets(), // It will overlay on top of the ListView
            ),
          ],
        ),
      ),
    );
  }
}
