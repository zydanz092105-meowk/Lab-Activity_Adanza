import 'package:flutter/material.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

enum ReportUiState { idle, loading, success, empty, error }

class ReportFormScreen extends StatefulWidget {
  const ReportFormScreen({super.key});

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  final _formKey = GlobalKey<FormState>();
  ReportUiState _uiState = ReportUiState.idle;
  bool _simulateFailure = false;

  Future<void> submitReport() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _uiState = ReportUiState.loading);
    
    try {
      await Future<void>.delayed(const Duration(seconds: 2));
      if (_simulateFailure) throw Exception('Simulated failure');
      if (!mounted) return;
      setState(() => _uiState = ReportUiState.success);
    } catch (_) {
      if (!mounted) return;
      setState(() => _uiState = ReportUiState.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Disaster Report Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_uiState == ReportUiState.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_uiState == ReportUiState.success) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Report Submitted Successfully!', style: TextStyle(fontSize: 18, color: Colors.green)),
            const SizedBox(height: 16),
            AppButton(text: 'Submit Another', onPressed: () => setState(() => _uiState = ReportUiState.idle)),
          ],
        ),
      );
    }
    if (_uiState == ReportUiState.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Failed to submit report.', style: TextStyle(fontSize: 18, color: Colors.red)),
            const SizedBox(height: 16),
            AppButton(text: 'Retry', onPressed: submitReport),
          ],
        ),
      );
    }
    if (_uiState == ReportUiState.empty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No reports found in this area.'),
            const SizedBox(height: 16),
            AppButton(text: 'Go Back', onPressed: () => setState(() => _uiState = ReportUiState.idle)),
          ],
        ),
      );
    }

    return Form(
      key: _formKey,
      child: ListView(
        children: [
          AppTextField(
            label: 'Report Title (e.g., Flood in Magallanes)',
            validator: (value) => value == null || value.isEmpty ? 'This field is required' : null,
          ),
          AppTextField(
            label: 'Location / Details',
            validator: (value) => value == null || value.isEmpty ? 'This field is required' : null,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Checkbox(
                value: _simulateFailure, 
                onChanged: (val) => setState(() => _simulateFailure = val ?? false)
              ),
              const Text('Simulate Error (For Testing)')
            ],
          ),
          const SizedBox(height: 16),
          AppButton(text: 'Submit Report', onPressed: submitReport),
          const SizedBox(height: 16),
          AppButton(text: 'View Empty State', onPressed: () => setState(() => _uiState = ReportUiState.empty)),
        ],
      ),
    );
  }
}