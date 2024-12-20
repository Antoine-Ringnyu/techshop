import 'package:flutter/material.dart';
import 'package:techrx/features/Welcome/presentation/components/sample_ticket.dart';
import 'package:techrx/features/auth/presentation/pages/auth_page.dart';
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
          color: Theme.of(context).colorScheme.inversePrimary, // Change this to your desired color
         ),
          backgroundColor: Theme.of(context).colorScheme.secondary,

          //App logo
          title: Text(
            'T e c h R x',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              color: Theme.of(context).colorScheme.inversePrimary,
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
        drawer: const Drawer(),

        //BODY
        body: ListView(children: [
          //CREATE TICKET
          const CreateTicket(),

          //SAMPLE TICKETS
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
            decoration: const BoxDecoration(
                // color: Colors.white
                ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SampleTicket(),
                SizedBox(height: 24,),
                SampleTicket(),
                SizedBox(height: 24,),
                SampleTicket(),
              ],
            )
          )
        ]),
      ),
    );
  }
}
