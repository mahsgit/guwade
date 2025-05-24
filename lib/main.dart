import 'package:buddy/features/home/presentation/pages/dashboard.dart';
import 'package:buddy/features/profile/presentation/pages/profile.dart';
import 'package:buddy/features/science/presentation/bloc/quiz_bloc.dart';
import 'package:buddy/features/storytelling/presentation/bloc/storytelling_bloc.dart';
import 'package:buddy/features/storytelling/presentation/pages/story.dart';
import 'package:buddy/features/storytelling/presentation/pages/vocabulary_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/injection/injection_container.dart' as di;
import 'features/auth/presentation/pages/login_page.dart';
import 'features/onboarding/slide1.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

/// Main entry point of the application
void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await di.init();

  // Run the app
  runApp(const MyApp());
}

/// Root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<AuthBloc>(),
        ),
        BlocProvider(
          create: (_) => di.sl<StorytellingBloc>(),
        ),
        BlocProvider(
          create: (_) => di.sl<QuizBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Buddy App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const OnboardingPage1(),
          '/login': (context) => const LoginPage(),
          '/dashboard': (context) => const DashboardPage(),
          '/story': (context) => const StorySelectionPage(),
          '/vocabulary': (context) => const VocabularyPage(),
          '/profile': (context) => const ProfilePage(),
          // '/quiz': (context) => const QuizPage(),
        },
      ),
    );
  }
}

