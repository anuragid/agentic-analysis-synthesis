import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/models/analysis_response.dart';
import '../../../../core/models/analysis_result.dart';
import '../../../../core/models/chunk.dart';
import '../../../../core/models/inference.dart';
import '../../../../core/models/pattern.dart';
import '../../../../core/models/insight.dart';
import '../../../../core/models/design_principle.dart';
import '../bloc/project_bloc.dart';

class ProjectDetailPage extends StatefulWidget {
  final String projectId;

  const ProjectDetailPage({super.key, required this.projectId});

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProjectBloc(apiService: Injection.apiService)
        ..add(const LoadProjects())
        ..add(LoadProjectLatestResult(widget.projectId)),
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<ProjectBloc, ProjectState>(
            builder: (context, state) {
              if (state is ProjectsLoaded) {
                final project = state.projects.firstWhere(
                  (p) => p.projectId == widget.projectId,
                  orElse: () => state.projects.first,
                );
                return Text(project.projectName);
              }
              return const Text('Project Details');
            },
          ),
          elevation: 2,
        ),
        body: BlocBuilder<ProjectBloc, ProjectState>(
          builder: (context, state) {
            if (state is ProjectResultLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProjectError) {
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
                      state.message.contains('404')
                          ? 'No analysis results yet for this project.'
                          : 'Error: ${state.message}',
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            } else if (state is ProjectResultLoaded) {
              final response = state.result as AnalysisResponse;
              final result = response.result;

              return Column(
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
                  // Main Content with Sidebar
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Sidebar - Vertical Tabs
                        Container(
                          width: 200,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            border: Border(
                              right: BorderSide(
                                color: Theme.of(context).dividerColor,
                                width: 1,
                              ),
                            ),
                          ),
                          child: ListView(
                            children: [
                              _buildVerticalTab(
                                icon: Icons.view_list,
                                label: 'Chunks',
                                index: 0,
                                isSelected: _selectedTabIndex == 0,
                              ),
                              _buildVerticalTab(
                                icon: Icons.lightbulb,
                                label: 'Inferences',
                                index: 1,
                                isSelected: _selectedTabIndex == 1,
                              ),
                              _buildVerticalTab(
                                icon: Icons.pattern,
                                label: 'Patterns',
                                index: 2,
                                isSelected: _selectedTabIndex == 2,
                              ),
                              _buildVerticalTab(
                                icon: Icons.insights,
                                label: 'Insights',
                                index: 3,
                                isSelected: _selectedTabIndex == 3,
                              ),
                              _buildVerticalTab(
                                icon: Icons.rule,
                                label: 'Principles',
                                index: 4,
                                isSelected: _selectedTabIndex == 4,
                              ),
                              _buildVerticalTab(
                                icon: Icons.info,
                                label: 'Metadata',
                                index: 5,
                                isSelected: _selectedTabIndex == 5,
                              ),
                            ],
                          ),
                        ),
                        // Right Content Area
                        Expanded(
                          child: _buildTabContent(result, _selectedTabIndex),
                        ),
                      ],
                    ),
                  ),
                ],
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

  Widget _buildVerticalTab({
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(AnalysisResult result, int index) {
    switch (index) {
      case 0:
        return _buildChunksTab(result.chunks);
      case 1:
        return _buildInferencesTab(result.inferences);
      case 2:
        return _buildPatternsTab(result.patterns);
      case 3:
        return _buildInsightsTab(result.insights);
      case 4:
        return _buildDesignPrinciplesTab(result.designPrinciples);
      case 5:
        return _buildMetadataTab(result.metadata);
      default:
        return _buildChunksTab(result.chunks);
    }
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
