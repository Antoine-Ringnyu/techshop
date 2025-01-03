import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techrx/features/auth/data/auth_gate.dart';
import 'package:techrx/features/searchTickets/presentation/cubit/search_cubit.dart';
import 'package:techrx/features/ticket/data/supaabase_ticket_repo.dart';
import 'package:techrx/themes/light_mode.dart';

class MyApp extends StatelessWidget {
  //search repo
  final supabaseSearchRepo = SupaabaseTicketRepo();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchCubit>(
      create: (context) => SearchCubit(ticketRepo: supabaseSearchRepo),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        title: 'TechRx',
        home: const AuthGate(),
      ),
    );
  }
}
