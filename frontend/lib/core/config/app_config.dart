class AppConfig {
  // Backend API base URL
  // For development, you can use localhost with port
  // For production, update this to your deployed backend URL
  static const String baseUrl = 'http://localhost:8000';
  
  // API endpoints
  static const String healthEndpoint = '/health';
  static const String analyzeEndpoint = '/analyze';
  static const String implementationsEndpoint = '/implementations';
  static const String statsEndpoint = '/stats';
  static const String analysesEndpoint = '/analyses';
  static const String projectsEndpoint = '/projects';
  static const String uploadEndpoint = '/upload';
  
  // Get full API URL
  static String getApiUrl(String endpoint) {
    return '$baseUrl$endpoint';
  }
}

