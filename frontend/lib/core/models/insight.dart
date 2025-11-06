import 'package:json_annotation/json_annotation.dart';

part 'insight.g.dart';

@JsonSerializable()
class Insight {
  final String headline;
  final String explanation;
  final String patternId;
  final bool nonConsensus;
  final bool firstPrinciples;
  final double impactScore;

  const Insight({
    required this.headline,
    required this.explanation,
    required this.patternId,
    required this.nonConsensus,
    required this.firstPrinciples,
    required this.impactScore,
  });

  factory Insight.fromJson(Map<String, dynamic> json) =>
      _$InsightFromJson(json);

  Map<String, dynamic> toJson() => _$InsightToJson(this);
}

