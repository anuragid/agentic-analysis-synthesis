// GENERATED CODE - DO NOT MODIFY BY HAND
// Run: flutter pub run build_runner build --delete-conflicting-outputs

part of 'analysis_response.dart';

AnalysisResponse _$AnalysisResponseFromJson(Map<String, dynamic> json) =>
    AnalysisResponse(
      requestId: json['request_id'] as String,
      status: json['status'] as String,
      message: json['message'] as String?,
      timestamp: json['timestamp'] as String?,
      implementation: json['implementation'] as String?,
      chunks: (json['chunks'] as List<dynamic>?)
              ?.map((e) => Chunk.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      inferences: (json['inferences'] as List<dynamic>?)
              ?.map((e) => Inference.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      patterns: (json['patterns'] as List<dynamic>?)
              ?.map((e) => Pattern.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      insights: (json['insights'] as List<dynamic>?)
              ?.map((e) => Insight.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      designPrinciples: (json['design_principles'] as List<dynamic>?)
              ?.map((e) => DesignPrinciple.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      metadata: json['metadata'] as Map<String, dynamic>?,
      executionTime: (json['execution_time'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AnalysisResponseToJson(AnalysisResponse instance) =>
    <String, dynamic>{
      'request_id': instance.requestId,
      'status': instance.status,
      'message': instance.message,
      'timestamp': instance.timestamp,
      'implementation': instance.implementation,
      'chunks': instance.chunks.map((e) => e.toJson()).toList(),
      'inferences': instance.inferences.map((e) => e.toJson()).toList(),
      'patterns': instance.patterns.map((e) => e.toJson()).toList(),
      'insights': instance.insights.map((e) => e.toJson()).toList(),
      'design_principles':
          instance.designPrinciples.map((e) => e.toJson()).toList(),
      'metadata': instance.metadata,
      'execution_time': instance.executionTime,
    };

