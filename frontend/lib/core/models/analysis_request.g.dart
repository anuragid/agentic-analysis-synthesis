// GENERATED CODE - DO NOT MODIFY BY HAND
// Run: flutter pub run build_runner build --delete-conflicting-outputs

part of 'analysis_request.dart';

AnalysisRequest _$AnalysisRequestFromJson(Map<String, dynamic> json) =>
    AnalysisRequest(
      projectName: json['project_name'] as String,
      researchData: json['research_data'] as String?,
      s3FilePath: json['s3_file_path'] as String?,
      implementation: json['implementation'] as String? ?? 'hybrid',
      includeMetadata: json['include_metadata'] as bool? ?? true,
    );

Map<String, dynamic> _$AnalysisRequestToJson(AnalysisRequest instance) =>
    <String, dynamic>{
      'project_name': instance.projectName,
      'research_data': instance.researchData,
      's3_file_path': instance.s3FilePath,
      'implementation': instance.implementation,
      'include_metadata': instance.includeMetadata,
    };

