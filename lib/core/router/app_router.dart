import 'package:go_router/go_router.dart';
import 'package:saludxchiapas_frontend/features/auth/presentation/pages/login_page.dart';
import 'package:saludxchiapas_frontend/features/auth/presentation/pages/register_page.dart';
import 'package:saludxchiapas_frontend/features/home/presentation/pages/home_page.dart';
import 'package:saludxchiapas_frontend/features/about/presentation/pages/about_us_page.dart';
import 'package:saludxchiapas_frontend/features/symptom_checker/presentation/pages/analysis_results_page.dart';
import 'package:saludxchiapas_frontend/features/symptom_checker/presentation/pages/symptom_checker_page.dart';
import 'package:saludxchiapas_frontend/features/hospitals/presentation/pages/hospitals_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/symptom-checker',
      name: 'symptom-checker',
      builder: (context, state) => const SymptomCheckerPage(),
      routes: [
        // Sub-ruta de /symptom-checker
        GoRoute(
          path: 'results',
          name: 'symptom-results',
          builder: (context, state) => const AnalysisResultsPage(),
        ),
      ],
    ),
    GoRoute(
      path: '/about',
      name: 'about',
      builder: (context, state) => const AboutUsPage(),
    ),
    GoRoute(
      path: '/hospitals',
      name: 'hospitals',
      builder: (context, state) => const HospitalsPage(),
    ),
  ],
);
