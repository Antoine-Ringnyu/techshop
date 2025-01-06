/*

  Auth states

*/

import 'package:techrx/features/auth/domain/entities/app_user.dart';

abstract class AuthState {}

//initial
class Authinitial extends AuthState {}

//loading...
class Authloading extends AuthState {}

//authenticated
class Authenticated extends AuthState {
  final AppUser user;
  Authenticated(this.user);
}

//unauthenticated
class Unauthenticated extends AuthState {}

//errors..
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
