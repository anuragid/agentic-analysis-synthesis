part of 'analysis_bloc.dart';

abstract class AnalysisState extends Equatable {
  const AnalysisState();

  @override
  List<Object?> get props => [];
}

class AnalysisInitial extends AnalysisState {}

class AnalysisLoading extends AnalysisState {}

class AnalysesLoading extends AnalysisState {}

class AnalysisSubmitted extends AnalysisState {
  final AnalysisResponse response;

  const AnalysisSubmitted(this.response);

  @override
  List<Object?> get props => [response];
}

class AnalysisLoaded extends AnalysisState {
  final AnalysisResponse response;

  const AnalysisLoaded(this.response);

  @override
  List<Object?> get props => [response];
}

class AnalysesLoaded extends AnalysisState {
  final List<Map<String, dynamic>> analyses;

  const AnalysesLoaded(this.analyses);

  @override
  List<Object?> get props => [analyses];
}

class AnalysisDeleted extends AnalysisState {
  final String requestId;

  const AnalysisDeleted(this.requestId);

  @override
  List<Object?> get props => [requestId];
}

class AnalysisError extends AnalysisState {
  final String message;

  const AnalysisError(this.message);

  @override
  List<Object?> get props => [message];
}

