import 'package:json_annotation/json_annotation.dart';
import 'analysis_result.dart';
import 'chunk.dart';
import 'inference.dart';
import 'pattern.dart';
import 'insight.dart';
import 'design_principle.dart';

part 'analysis_response.g.dart';

@JsonSerializable()
class AnalysisResponse {
  final String requestId;
  final String status;
  final String? message;
  final String? timestamp;
  final String? implementation;

  // Analysis result fields (matching API structure)
  final List<Chunk> chunks;
  final List<Inference> inferences;
  final List<Pattern> patterns;
  final List<Insight> insights;
  final List<DesignPrinciple> designPrinciples;
  final Map<String, dynamic>? metadata;
  final double? executionTime;

  const AnalysisResponse({
    required this.requestId,
    required this.status,
    this.message,
    this.timestamp,
    this.implementation,
    required this.chunks,
    required this.inferences,
    required this.patterns,
    required this.insights,
    required this.designPrinciples,
    this.metadata,
    this.executionTime,
  });

  // Computed property to get structured result
  AnalysisResult get result => AnalysisResult(
    chunks: chunks,
    inferences: inferences,
    patterns: patterns,
    insights: insights,
    designPrinciples: designPrinciples,
    metadata: metadata,
    executionTime: executionTime,
  );

  factory AnalysisResponse.fromJson(Map<String, dynamic> json) =>
      _$AnalysisResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AnalysisResponseToJson(this);
}
