import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignUpEvent extends AuthEvent {
  final String email;
  final String password;
  final String username;

  SignUpEvent({required this.email, required this.password, required this.username});

  @override
  List<Object?> get props => [email, password, username];
}

class LogInEvent extends AuthEvent {
  final String email;
  final String password;

  LogInEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class LogOutEvent extends AuthEvent {}
