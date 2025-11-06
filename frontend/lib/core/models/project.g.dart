// GENERATED CODE - DO NOT MODIFY BY HAND
// Run: flutter pub run build_runner build --delete-conflicting-outputs

part of 'project.dart';

Project _$ProjectFromJson(Map<String, dynamic> json) => Project(
      projectId: json['project_id'] as String,
      projectName: json['project_name'] as String,
      resultPath: json['result_path'] as String,
      latestRequestId: json['latest_request_id'] as String,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
      'project_id': instance.projectId,
      'project_name': instance.projectName,
      'result_path': instance.resultPath,
      'latest_request_id': instance.latestRequestId,
      'created_at': instance.createdAt,
    };

