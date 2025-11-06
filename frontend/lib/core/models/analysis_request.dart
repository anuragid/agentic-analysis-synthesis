import 'package:json_annotation/json_annotation.dart';

part 'analysis_request.g.dart';

@JsonSerializable()
class AnalysisRequest {
  final String projectName;
  final String? researchData;
  final String? s3FilePath;
  final String implementation;
  final bool includeMetadata;

  const AnalysisRequest({
    required this.projectName,
    this.researchData,
    this.s3FilePath,
    this.implementation = 'hybrid',
    this.includeMetadata = true,
  });

  factory AnalysisRequest.fromJson(Map<String, dynamic> json) =>
      _$AnalysisRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AnalysisRequestToJson(this);
}

