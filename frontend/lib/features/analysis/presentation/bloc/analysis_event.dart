part of 'analysis_bloc.dart';

abstract class AnalysisEvent extends Equatable {
  const AnalysisEvent();

  @override
  List<Object?> get props => [];
}

class SubmitAnalysis extends AnalysisEvent {
  final AnalysisRequest request;

  const SubmitAnalysis(this.request);

  @override
  List<Object?> get props => [request];
}

class LoadAnalysis extends AnalysisEvent {
  final String requestId;

  const LoadAnalysis(this.requestId);

  @override
  List<Object?> get props => [requestId];
}

class LoadAnalyses extends AnalysisEvent {
  const LoadAnalyses();
}

class DeleteAnalysis extends AnalysisEvent {
  final String requestId;

  const DeleteAnalysis(this.requestId);

  @override
  List<Object?> get props => [requestId];
}

