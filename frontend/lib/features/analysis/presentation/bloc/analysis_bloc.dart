import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/models/analysis_request.dart';
import '../../../../core/models/analysis_response.dart';
import '../../../../core/services/api_service.dart';

part 'analysis_event.dart';
part 'analysis_state.dart';

class AnalysisBloc extends Bloc<AnalysisEvent, AnalysisState> {
  final ApiService apiService;

  AnalysisBloc({required this.apiService}) : super(AnalysisInitial()) {
    on<SubmitAnalysis>(_onSubmitAnalysis);
    on<LoadAnalysis>(_onLoadAnalysis);
    on<LoadAnalyses>(_onLoadAnalyses);
    on<DeleteAnalysis>(_onDeleteAnalysis);
  }

  Future<void> _onSubmitAnalysis(
    SubmitAnalysis event,
    Emitter<AnalysisState> emit,
  ) async {
    emit(AnalysisLoading());
    try {
      final response = await apiService.submitAnalysis(event.request);
      emit(AnalysisSubmitted(response));
    } catch (e) {
      emit(AnalysisError(e.toString()));
    }
  }

  Future<void> _onLoadAnalysis(
    LoadAnalysis event,
    Emitter<AnalysisState> emit,
  ) async {
    emit(AnalysisLoading());
    try {
      final response = await apiService.getAnalysis(event.requestId);
      emit(AnalysisLoaded(response));
    } catch (e) {
      emit(AnalysisError(e.toString()));
    }
  }

  Future<void> _onLoadAnalyses(
    LoadAnalyses event,
    Emitter<AnalysisState> emit,
  ) async {
    emit(AnalysesLoading());
    try {
      final analyses = await apiService.getAnalyses();
      emit(AnalysesLoaded(analyses));
    } catch (e) {
      emit(AnalysisError(e.toString()));
    }
  }

  Future<void> _onDeleteAnalysis(
    DeleteAnalysis event,
    Emitter<AnalysisState> emit,
  ) async {
    try {
      await apiService.deleteAnalysis(event.requestId);
      emit(AnalysisDeleted(event.requestId));
      // Reload analyses after deletion
      add(LoadAnalyses());
    } catch (e) {
      emit(AnalysisError(e.toString()));
    }
  }
}
