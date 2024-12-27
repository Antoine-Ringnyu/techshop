import 'package:flutter/material.dart';
import 'package:techrx/features/ticket/domain/entities/ticket.dart';

class TicketPage extends StatefulWidget {
  final Ticket ticket;
  const TicketPage({super.key, required this.ticket});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      // ),
      //body
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            leading:  const Icon(Icons.insert_emoticon_sharp),
            // title: const Text('Ticked ID'),
            expandedHeight: 200,
            floating: true,
            pinned: true,

            //flexible space
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.ticket.id.toString()),
            ),
          ),

          //sliver items
          SliverToBoxAdapter(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(bottomLeft:Radius.circular(50),bottomRight: Radius.circular(50)),
              child: Container(
                padding: const EdgeInsets.all(30),
                color:Theme.of(context).colorScheme.primary ,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Ticket  3112680-1',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                          ),
                        ),
                        Icon(
                          Icons.perm_contact_cal_rounded,
                          color: Theme.of(context).colorScheme.surface,
                          size: 50,
                        )
                      ],
                    ),

                    //ticket status
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(45),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 8,),
                        const Text(
                          'In progress',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50,),
                    //call technician
                      ClipRRect(
                       borderRadius: BorderRadius.circular(12),
                        child: Container(
                          color: Theme.of(context).colorScheme.secondary,
                          padding: const EdgeInsets.all(8),
                          child: const Center(child: Text(
                            'Call Technician',
                            style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                          ),),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50,horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 30,
                      ),
                      const SizedBox(width: 25,),
                      Expanded(child: Text(
                        widget.ticket.location,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 18
                        ),
                      ))
                    ],
                  ),

                  const SizedBox(height: 30,),

                  //issue description
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.notes,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 30,
                      ),
                      const SizedBox(width: 25,),
                      Expanded(child: Text(
                        widget.ticket.issueDescription,
                        style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                          // fontSize: 18
                        ),
                      ))
                    ],
                  ),

                  const SizedBox(height: 30,),

                  //issue contact
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.contact_phone_outlined,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 30,
                      ),
                      const SizedBox(width: 25,),
                      Expanded(child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                          color: Theme.of(context).colorScheme.secondary,
                          child: Text(
                            widget.ticket.contact,
                            style: TextStyle(
                              // fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.inversePrimary,
                              fontSize: 16
                            ),
                          ),
                        ),
                      ))
                    ],
                  ),

                  const SizedBox(height: 30,),

                  //attachment
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 32,
                      ),
                      const SizedBox(width: 25,),
                      Expanded(child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                          color: Theme.of(context).colorScheme.inversePrimary,
                          child: Text(
                            widget.ticket.contact,
                            style: TextStyle(
                              // fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 16
                            ),
                          ),
                        ),
                      ))
                    ],
                  )
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: ClipRRect(
              child: Container(
                padding: const EdgeInsets.all(30),
                height: 300,
                color:Theme.of(context).colorScheme.inversePrimary ,
              ),
            ),
          )
        ],
      ), // Corrected here
    );
  }
}
