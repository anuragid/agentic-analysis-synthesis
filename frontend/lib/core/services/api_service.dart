import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/analysis_request.dart';
import '../models/analysis_response.dart';
import '../models/project.dart';

class ApiService {
  final String baseUrl;

  ApiService({String? baseUrl}) : baseUrl = baseUrl ?? AppConfig.baseUrl;

  Future<Map<String, dynamic>> getHealth() async {
    try {
      final response = await http.get(
        Uri.parse(AppConfig.getApiUrl(AppConfig.healthEndpoint)),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to get health status');
      }
    } catch (e) {
      throw Exception('Error checking health: $e');
    }
  }

  Future<AnalysisResponse> submitAnalysis(AnalysisRequest request) async {
    try {
      final response = await http.post(
        Uri.parse(AppConfig.getApiUrl(AppConfig.analyzeEndpoint)),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AnalysisResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
        throw Exception('Failed to submit analysis: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error submitting analysis: $e');
    }
  }

  Future<AnalysisResponse> getAnalysis(String requestId) async {
    try {
      final response = await http.get(
        Uri.parse(
          AppConfig.getApiUrl('${AppConfig.analyzeEndpoint}/$requestId'),
        ),
      );

      if (response.statusCode == 200) {
        return AnalysisResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
        throw Exception('Failed to get analysis: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error getting analysis: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAnalyses() async {
    try {
      final response = await http.get(
        Uri.parse(AppConfig.getApiUrl(AppConfig.analysesEndpoint)),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return List<Map<String, dynamic>>.from(data['analyses'] ?? []);
      } else {
        throw Exception('Failed to get analyses: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error getting analyses: $e');
    }
  }

  Future<List<String>> getImplementations() async {
    try {
      final response = await http.get(
        Uri.parse(AppConfig.getApiUrl(AppConfig.implementationsEndpoint)),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return List<String>.from(data['implementations'] ?? []);
      } else {
        throw Exception('Failed to get implementations: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error getting implementations: $e');
    }
  }

  Future<Map<String, dynamic>> getStats() async {
    try {
      final response = await http.get(
        Uri.parse(AppConfig.getApiUrl(AppConfig.statsEndpoint)),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to get stats: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error getting stats: $e');
    }
  }

  Future<void> deleteAnalysis(String requestId) async {
    try {
      final response = await http.delete(
        Uri.parse(
          AppConfig.getApiUrl('${AppConfig.analyzeEndpoint}/$requestId'),
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete analysis: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error deleting analysis: $e');
    }
  }

  // Project management methods
  Future<List<Project>> getProjects() async {
    try {
      final response = await http.get(
        Uri.parse(AppConfig.getApiUrl(AppConfig.projectsEndpoint)),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data
            .map((json) => Project.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to get projects: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error getting projects: $e');
    }
  }

  Future<Project> createProject(String projectName) async {
    try {
      final response = await http.post(
        Uri.parse(AppConfig.getApiUrl(AppConfig.projectsEndpoint)),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'project_name': projectName}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Project.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
        throw Exception('Failed to create project: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating project: $e');
    }
  }

  Future<AnalysisResponse> getProjectLatestResult(String projectId) async {
    try {
      final response = await http.get(
        Uri.parse(
          AppConfig.getApiUrl(
            '${AppConfig.projectsEndpoint}/$projectId/latest-result',
          ),
        ),
      );

      if (response.statusCode == 200) {
        return AnalysisResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
        throw Exception(
          'Failed to get project latest result: ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error getting project latest result: $e');
    }
  }

  Future<Map<String, dynamic>> uploadFile(
    List<int> fileBytes,
    String filename,
  ) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(AppConfig.getApiUrl(AppConfig.uploadEndpoint)),
      );

      request.files.add(
        http.MultipartFile.fromBytes('file', fileBytes, filename: filename),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to upload file: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error uploading file: $e');
    }
  }
}
