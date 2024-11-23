import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<SignUpEvent>((event, emit) async {
      try {
        emit(AuthLoading());
        await authRepository.signUp(
            event.email, event.password, event.username);
        emit(AuthAuthenticated(event.username));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<LogInEvent>((event, emit) async {
      try {
        emit(AuthLoading());
        await authRepository.logIn(event.email, event.password);

        // Fetch the current user
        final user = authRepository.currentUser;
        if (user != null) {
          // Retrieve username from Firestore
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

          final username = userDoc['username'] as String;

          // Emit Authenticated state with username
          emit(AuthAuthenticated(username));
        } else {
          emit(AuthError('Failed to fetch user information.'));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<LogOutEvent>((event, emit) async {
      await authRepository.logOut();
      emit(AuthUnauthenticated());
    });
  }
}
