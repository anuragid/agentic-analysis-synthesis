import '../../features/analysis/presentation/bloc/analysis_bloc.dart';
import '../services/api_service.dart';

class Injection {
  static final ApiService _apiService = ApiService();
  
  static ApiService get apiService => _apiService;
  
  static AnalysisBloc get analysisBloc => AnalysisBloc(apiService: _apiService);
}

