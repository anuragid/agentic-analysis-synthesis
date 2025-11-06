import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/models/chunk.dart';
import '../../../../core/models/inference.dart';
import '../../../../core/models/pattern.dart';
import '../../../../core/models/insight.dart';
import '../../../../core/models/design_principle.dart';
import '../bloc/analysis_bloc.dart';

class AnalysisDetailPage extends StatelessWidget {
  final String requestId;

  const AnalysisDetailPage({super.key, required this.requestId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AnalysisBloc(apiService: ApiService())..add(LoadAnalysis(requestId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Analysis: ${requestId.substring(0, 8)}...'),
          elevation: 2,
        ),
        body: BlocBuilder<AnalysisBloc, AnalysisState>(
          builder: (context, state) {
            if (state is AnalysisLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AnalysisError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${state.message}',
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            } else if (state is AnalysisLoaded) {
              final response = state.response;
              final result = response.result;

              return DefaultTabController(
                length: 6,
                child: Column(
                  children: [
                    // Header Info Card
                    Card(
                      margin: const EdgeInsets.all(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow('Request ID', response.requestId),
                            _buildInfoRow('Status', response.status),
                            if (response.implementation != null)
                              _buildInfoRow(
                                'Implementation',
                                response.implementation!,
                              ),
                            if (response.timestamp != null)
                              _buildInfoRow('Timestamp', response.timestamp!),
                            if (result.executionTime != null)
                              _buildInfoRow(
                                'Execution Time',
                                '${result.executionTime!.toStringAsFixed(2)}s',
                              ),
                          ],
                        ),
                      ),
                    ),
                    // Tabs
                    const TabBar(
                      isScrollable: true,
                      tabs: [
                        Tab(text: 'Chunks', icon: Icon(Icons.view_list)),
                        Tab(text: 'Inferences', icon: Icon(Icons.lightbulb)),
                        Tab(text: 'Patterns', icon: Icon(Icons.pattern)),
                        Tab(text: 'Insights', icon: Icon(Icons.insights)),
                        Tab(text: 'Principles', icon: Icon(Icons.rule)),
                        Tab(text: 'Metadata', icon: Icon(Icons.info)),
                      ],
                    ),
                    // Tab Views
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildChunksTab(result.chunks),
                          _buildInferencesTab(result.inferences),
                          _buildPatternsTab(result.patterns),
                          _buildInsightsTab(result.insights),
                          _buildDesignPrinciplesTab(result.designPrinciples),
                          _buildMetadataTab(result.metadata),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: Text('No data available'));
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildChunksTab(List<Chunk> chunks) {
    if (chunks.isEmpty) {
      return const Center(child: Text('No chunks available'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: chunks.length,
      itemBuilder: (context, index) {
        final chunk = chunks[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: _getTypeColor(chunk.type),
              child: Text(
                chunk.id,
                style: const TextStyle(fontSize: 10, color: Colors.white),
              ),
            ),
            title: Text(
              chunk.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              'Type: ${chunk.type} • Confidence: ${chunk.confidence.toStringAsFixed(2)}',
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Source', chunk.source),
                    _buildDetailRow('Type', chunk.type),
                    _buildDetailRow(
                      'Confidence',
                      chunk.confidence.toStringAsFixed(2),
                    ),
                    if (chunk.tags.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      const Text(
                        'Tags:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Wrap(
                        spacing: 8,
                        children: chunk.tags
                            .map(
                              (tag) => Chip(
                                label: Text(tag),
                                labelStyle: const TextStyle(fontSize: 12),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInferencesTab(List<Inference> inferences) {
    if (inferences.isEmpty) {
      return const Center(child: Text('No inferences available'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: inferences.length,
      itemBuilder: (context, index) {
        final inference = inferences[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                inference.chunkId,
                style: const TextStyle(fontSize: 10, color: Colors.white),
              ),
            ),
            title: Text(
              inference.meanings.first,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              'Confidence: ${inference.confidence.toStringAsFixed(2)}',
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Chunk ID', inference.chunkId),
                    if (inference.meanings.length > 1) ...[
                      const Text(
                        'Meanings:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      ...inference.meanings.map(
                        (meaning) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text('• $meaning'),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    _buildDetailRow('Importance', inference.importance),
                    _buildDetailRow('Context', inference.context),
                    _buildDetailRow(
                      'Confidence',
                      inference.confidence.toStringAsFixed(2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPatternsTab(List<Pattern> patterns) {
    if (patterns.isEmpty) {
      return const Center(child: Text('No patterns available'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: patterns.length,
      itemBuilder: (context, index) {
        final pattern = patterns[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: Colors.purple,
              child: Text(
                '${index + 1}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(pattern.name),
            subtitle: Text('Strength: ${pattern.strength.toStringAsFixed(2)}'),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Description', pattern.description),
                    _buildDetailRow(
                      'Strength',
                      pattern.strength.toStringAsFixed(2),
                    ),
                    if (pattern.themes.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      const Text(
                        'Themes:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Wrap(
                        spacing: 8,
                        children: pattern.themes
                            .map(
                              (theme) => Chip(
                                label: Text(theme),
                                labelStyle: const TextStyle(fontSize: 12),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                    if (pattern.relatedInferences.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      const Text(
                        'Related Inferences:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Wrap(
                        spacing: 8,
                        children: pattern.relatedInferences
                            .map(
                              (inf) => Chip(
                                label: Text(inf),
                                labelStyle: const TextStyle(fontSize: 12),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInsightsTab(List<Insight> insights) {
    if (insights.isEmpty) {
      return const Center(child: Text('No insights available'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: insights.length,
      itemBuilder: (context, index) {
        final insight = insights[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: Colors.orange,
              child: Text(
                '${index + 1}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              insight.headline,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Impact: ${insight.impactScore.toStringAsFixed(2)}'),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Headline', insight.headline),
                    _buildDetailRow('Explanation', insight.explanation),
                    _buildDetailRow('Pattern ID', insight.patternId),
                    _buildDetailRow(
                      'Impact Score',
                      insight.impactScore.toStringAsFixed(2),
                    ),
                    Row(
                      children: [
                        if (insight.nonConsensus)
                          Chip(
                            label: const Text('Non-Consensus'),
                            avatar: const Icon(Icons.flag, size: 16),
                          ),
                        const SizedBox(width: 8),
                        if (insight.firstPrinciples)
                          Chip(
                            label: const Text('First Principles'),
                            avatar: const Icon(Icons.science, size: 16),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDesignPrinciplesTab(List<DesignPrinciple> principles) {
    if (principles.isEmpty) {
      return const Center(child: Text('No design principles available'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: principles.length,
      itemBuilder: (context, index) {
        final principle = principles[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green,
              child: Text(
                '${index + 1}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              principle.principle,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Priority: ${principle.priority.toStringAsFixed(2)}',
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Principle', principle.principle),
                    _buildDetailRow(
                      'Design Direction',
                      principle.designDirection,
                    ),
                    _buildDetailRow(
                      'Priority',
                      principle.priority.toStringAsFixed(2),
                    ),
                    _buildDetailRow('Insight ID', principle.insightId),
                    if (principle.actionVerbs.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      const Text(
                        'Action Verbs:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Wrap(
                        spacing: 8,
                        children: principle.actionVerbs
                            .map(
                              (verb) => Chip(
                                label: Text(verb),
                                labelStyle: const TextStyle(fontSize: 12),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetadataTab(Map<String, dynamic>? metadata) {
    if (metadata == null || metadata.isEmpty) {
      return const Center(child: Text('No metadata available'));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: metadata.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 150,
                        child: Text(
                          '${entry.key}:',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Expanded(child: Text(entry.value.toString())),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'observation':
        return Colors.blue;
      case 'pain_point':
        return Colors.red;
      case 'behavior':
        return Colors.orange;
      case 'quote':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
