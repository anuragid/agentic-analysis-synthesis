import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/models/project.dart';
import '../../../../core/services/api_service.dart';

part 'project_event.dart';
part 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final ApiService apiService;

  ProjectBloc({required this.apiService}) : super(ProjectInitial()) {
    on<LoadProjects>(_onLoadProjects);
    on<CreateProject>(_onCreateProject);
    on<LoadProjectLatestResult>(_onLoadProjectLatestResult);
  }

  Future<void> _onLoadProjects(
    LoadProjects event,
    Emitter<ProjectState> emit,
  ) async {
    emit(ProjectsLoading());
    try {
      final projects = await apiService.getProjects();
      emit(ProjectsLoaded(projects));
    } catch (e) {
      emit(ProjectError(e.toString()));
    }
  }

  Future<void> _onCreateProject(
    CreateProject event,
    Emitter<ProjectState> emit,
  ) async {
    emit(ProjectCreating());
    try {
      final project = await apiService.createProject(event.projectName);
      emit(ProjectCreated(project));
      // Reload projects after creation
      add(LoadProjects());
    } catch (e) {
      emit(ProjectError(e.toString()));
    }
  }

  Future<void> _onLoadProjectLatestResult(
    LoadProjectLatestResult event,
    Emitter<ProjectState> emit,
  ) async {
    emit(ProjectResultLoading());
    try {
      final result = await apiService.getProjectLatestResult(event.projectId);
      emit(ProjectResultLoaded(result));
    } catch (e) {
      emit(ProjectError(e.toString()));
    }
  }
}

