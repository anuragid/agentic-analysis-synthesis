part of 'project_bloc.dart';

abstract class ProjectEvent extends Equatable {
  const ProjectEvent();

  @override
  List<Object?> get props => [];
}

class LoadProjects extends ProjectEvent {
  const LoadProjects();
}

class CreateProject extends ProjectEvent {
  final String projectName;

  const CreateProject(this.projectName);

  @override
  List<Object?> get props => [projectName];
}

class LoadProjectLatestResult extends ProjectEvent {
  final String projectId;

  const LoadProjectLatestResult(this.projectId);

  @override
  List<Object?> get props => [projectId];
}

