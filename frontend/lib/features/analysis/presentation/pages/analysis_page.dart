import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/models/analysis_request.dart';
import '../bloc/analysis_bloc.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  final _formKey = GlobalKey<FormState>();
  final _researchDataController = TextEditingController();
  String _selectedImplementation = 'hybrid';
  final List<String> _implementations = ['hybrid', 'openai', 'langchain'];

  @override
  void initState() {
    super.initState();
    _loadImplementations();
    context.read<AnalysisBloc>().add(const LoadAnalyses());
  }

  Future<void> _loadImplementations() async {
    try {
      final implementations = await Injection.apiService.getImplementations();
      if (implementations.isNotEmpty) {
        setState(() {
          _implementations.clear();
          _implementations.addAll(implementations);
          _selectedImplementation = implementations.first;
        });
      }
    } catch (e) {
      // Handle error silently or show snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading implementations: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _researchDataController.dispose();
    super.dispose();
  }

  void _submitAnalysis() {
    if (_formKey.currentState!.validate()) {
      final request = AnalysisRequest(
        projectName: 'Default Project', // TODO: Get from project selection
        researchData: _researchDataController.text,
        implementation: _selectedImplementation,
      );
      context.read<AnalysisBloc>().add(SubmitAnalysis(request));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Analysis'), elevation: 2),
      body: BlocConsumer<AnalysisBloc, AnalysisState>(
        listener: (context, state) {
          if (state is AnalysisSubmitted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Analysis submitted successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            context.go('/analysis/${state.response.requestId}');
          } else if (state is AnalysisError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Research Data',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _researchDataController,
                            maxLines: 10,
                            decoration: const InputDecoration(
                              hintText: 'Enter your research data here...',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter research data';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Implementation',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            initialValue: _selectedImplementation,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            items: _implementations
                                .map(
                                  (impl) => DropdownMenuItem(
                                    value: impl,
                                    child: Text(impl),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedImplementation = value;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: state is AnalysisLoading
                        ? null
                        : _submitAnalysis,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: state is AnalysisLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            'Submit Analysis',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
