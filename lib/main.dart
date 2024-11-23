import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_post/firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/post_screen.dart';
import 'blocs/auth/auth_bloc.dart';
import 'repositories/auth_repository.dart';
import 'blocs/post/post_bloc.dart';
import 'repositories/post_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository = AuthRepository();
  final AuthBloc authBloc = AuthBloc(AuthRepository());
  final PostRepository postRepository = PostRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<User?>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: const CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            // If user is logged in, navigate to PostScreen
            return PostScreen(
              authBloc: authBloc,
              postBloc: PostBloc(postRepository),
            );
          } else {
            // If user is not logged in, show the login screen
            return LoginScreen(authBloc: authBloc);
          }
        },
      ),
      routes: {
        '/login': (context) => LoginScreen(authBloc: authBloc),
        '/signup': (context) => SignupScreen(authBloc: authBloc),
        '/posts': (context) => PostScreen(
              authBloc: authBloc,
              postBloc: PostBloc(postRepository),
            ),
      },
    );
  }

  Future<User?> _checkLoginStatus() async {
    // Check if the user is already logged in
    return FirebaseAuth.instance.currentUser;
  }
}
