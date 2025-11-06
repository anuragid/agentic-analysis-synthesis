part of 'project_bloc.dart';

abstract class ProjectState extends Equatable {
  const ProjectState();

  @override
  List<Object?> get props => [];
}

class ProjectInitial extends ProjectState {}

class ProjectsLoading extends ProjectState {}

class ProjectCreating extends ProjectState {}

class ProjectsLoaded extends ProjectState {
  final List<Project> projects;

  const ProjectsLoaded(this.projects);

  @override
  List<Object?> get props => [projects];
}

class ProjectCreated extends ProjectState {
  final Project project;

  const ProjectCreated(this.project);

  @override
  List<Object?> get props => [project];
}

class ProjectResultLoading extends ProjectState {}

class ProjectResultLoaded extends ProjectState {
  final dynamic result; // AnalysisResponse

  const ProjectResultLoaded(this.result);

  @override
  List<Object?> get props => [result];
}

class ProjectError extends ProjectState {
  final String message;

  const ProjectError(this.message);

  @override
  List<Object?> get props => [message];
}

