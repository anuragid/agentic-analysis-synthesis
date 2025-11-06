import 'package:json_annotation/json_annotation.dart';
import 'chunk.dart';
import 'inference.dart';
import 'pattern.dart';
import 'insight.dart';
import 'design_principle.dart';

part 'analysis_result.g.dart';

@JsonSerializable()
class AnalysisResult {
  final List<Chunk> chunks;
  final List<Inference> inferences;
  final List<Pattern> patterns;
  final List<Insight> insights;
  final List<DesignPrinciple> designPrinciples;
  final Map<String, dynamic>? metadata;
  final double? executionTime;

  const AnalysisResult({
    required this.chunks,
    required this.inferences,
    required this.patterns,
    required this.insights,
    required this.designPrinciples,
    this.metadata,
    this.executionTime,
  });

  factory AnalysisResult.fromJson(Map<String, dynamic> json) =>
      _$AnalysisResultFromJson(json);

  Map<String, dynamic> toJson() => _$AnalysisResultToJson(this);
}
