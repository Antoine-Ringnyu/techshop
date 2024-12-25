import 'package:flutter/material.dart';
import 'package:techrx/features/Welcome/presentation/components/sample_tickets.dart';
import 'package:techrx/features/auth/presentation/pages/auth_page.dart';
import 'package:techrx/features/home/presentation/components/my_drawer.dart';
import 'package:techrx/features/searchTickets/presentation/components/search_tickets.dart';
import 'package:techrx/features/ticket/presentation/pages/create_ticket.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  //BUILDING UI
  Widget build(BuildContext context) {
    //BUILDING UI
    return SafeArea(
      child: Scaffold(
        //APPBAR
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: Theme.of(context)
                  .colorScheme
                  .inversePrimary // Change this to your desired color
              ),
          backgroundColor: Theme.of(context).colorScheme.secondary,

          //App logo
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
            //logout button
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

        //DRAWER
        drawer: MyDrawer(),

        //BODY
        body: ListView(children: [
          //SEARCH AND CREATE TICKET
          Container(
            padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 30),
            color: Theme.of(context).colorScheme.inversePrimary,
            child: const Column(
              children: [
                //SEARCH search ticket
                SearchTickets(),
                SizedBox(
                  height: 50,
                ),
                //CREATE TICKET
                CreateTicket(),
              ],
            ),
          ),

          //SAMPLE TICKETS
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
            child: SampleTickets(),
          ),
          Container(
            padding: const EdgeInsets.all(50),
            color: Theme.of(context).colorScheme.secondary,
          )
        ]),
      ),
    );
  }
}
