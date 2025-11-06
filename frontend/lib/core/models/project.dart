import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

@JsonSerializable()
class Project {
  final String projectId;
  final String projectName;
  final String resultPath;
  final String latestRequestId;
  final String? createdAt;

  const Project({
    required this.projectId,
    required this.projectName,
    required this.resultPath,
    required this.latestRequestId,
    this.createdAt,
  });

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}

