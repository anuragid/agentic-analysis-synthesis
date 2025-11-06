import 'package:json_annotation/json_annotation.dart';

part 'inference.g.dart';

@JsonSerializable()
class Inference {
  final String chunkId;
  final List<String> meanings;
  final String importance;
  final String context;
  final double confidence;

  const Inference({
    required this.chunkId,
    required this.meanings,
    required this.importance,
    required this.context,
    required this.confidence,
  });

  factory Inference.fromJson(Map<String, dynamic> json) =>
      _$InferenceFromJson(json);

  Map<String, dynamic> toJson() => _$InferenceToJson(this);
}

