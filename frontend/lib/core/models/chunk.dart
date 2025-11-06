import 'package:json_annotation/json_annotation.dart';

part 'chunk.g.dart';

@JsonSerializable()
class Chunk {
  final String id;
  final String content;
  final String source;
  final String type;
  final double confidence;
  final List<String> tags;

  const Chunk({
    required this.id,
    required this.content,
    required this.source,
    required this.type,
    required this.confidence,
    required this.tags,
  });

  factory Chunk.fromJson(Map<String, dynamic> json) => _$ChunkFromJson(json);

  Map<String, dynamic> toJson() => _$ChunkToJson(this);
}
