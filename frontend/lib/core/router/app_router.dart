import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/analysis/presentation/pages/analysis_page.dart';
import '../../features/analysis/presentation/pages/analysis_detail_page.dart';
import '../../features/projects/presentation/pages/projects_page.dart';
import '../../features/projects/presentation/pages/project_detail_page.dart';

class AppRouter {
  static const String home = '/';
  static const String projects = '/projects';
  static const String projectDetail = '/projects/:id';
  static const String analysis = '/analysis';
  static const String analysisDetail = '/analysis/:id';

  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    initialLocation: home,
    routes: [
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: projects,
        name: 'projects',
        builder: (context, state) => const ProjectsPage(),
      ),
      GoRoute(
        path: projectDetail,
        name: 'projectDetail',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ProjectDetailPage(projectId: id);
        },
      ),
      GoRoute(
        path: analysis,
        name: 'analysis',
        builder: (context, state) => const AnalysisPage(),
      ),
      GoRoute(
        path: analysisDetail,
        name: 'analysisDetail',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return AnalysisDetailPage(requestId: id);
        },
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Error: ${state.error}'))),
  );
}
