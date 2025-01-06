import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techrx/features/Welcome/presentation/pages/welcome_page.dart';
import 'package:techrx/features/auth/data/supabase_auth_repo.dart';
import 'package:techrx/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:techrx/features/auth/presentation/cubits/auth_states.dart';
import 'package:techrx/features/profile/presentation/pages/profile_page.dart';
import 'package:techrx/features/searchTickets/presentation/cubit/search_cubit.dart';
import 'package:techrx/features/ticket/data/supaabase_ticket_repo.dart';
import 'package:techrx/themes/light_mode.dart';

class MyApp extends StatelessWidget {
  //auth repo
  final supabaseAuthRepo = SupabaseAuthRepo();

  //search repo
  final supabaseSearchRepo = SupaabaseTicketRepo();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //provide cubit to app
    return MultiBlocProvider(
      providers: [
        //auth cubit
        BlocProvider<AuthCubit>(
          create: (context) =>
              AuthCubit(authRepo: supabaseAuthRepo)..checkAuth(),
        ),

        //search cubit
        BlocProvider<SearchCubit>(
          create: (context) => SearchCubit(ticketRepo: supabaseSearchRepo),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        title: 'TechRx',
        home: BlocConsumer<AuthCubit, AuthState>(
          builder: (context, authState) {
            print(authState);

            //unauthenticated -> auth page(login/register)
            if (authState is Unauthenticated) {
              return const WelcomePage();
            }

            //authenticated -> home page
            if (authState is Authenticated) {
              return const ProfilePage();
            }

            //loading...
            else {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },

          //listen for any errors..
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
      ),
    );
  }
}
