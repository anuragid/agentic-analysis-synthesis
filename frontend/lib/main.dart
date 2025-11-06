import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/router/app_router.dart';
import 'core/di/injection.dart';
import 'features/analysis/presentation/bloc/analysis_bloc.dart';
import 'features/projects/presentation/bloc/project_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AnalysisBloc>(
          create: (context) => Injection.analysisBloc,
        ),
        BlocProvider<ProjectBloc>(
          create: (context) => ProjectBloc(apiService: Injection.apiService),
        ),
      ],
      child: MaterialApp.router(
        title: 'Design Analysis',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
