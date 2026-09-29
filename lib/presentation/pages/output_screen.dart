import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../cubit/calculator_state.dart';

import 'package:url_launcher/url_launcher.dart';

class OutputScreen extends StatefulWidget {
  final CalculatorState state;

  const OutputScreen({super.key, required this.state});

  @override
  State<OutputScreen> createState() => _OutputScreenState();
}

class _OutputScreenState extends State<OutputScreen> {
  bool _showBreakdown = false;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final result = widget.state.result;
    final state = widget.state;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Total Quote Card
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text(
                      'TOTAL ESTIMATE',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      currencyFormat.format(result.totalEstimate),
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 24),
                    _buildDataRow(
                      'Date',
                      DateFormat('MM.dd.yyyy').format(DateTime.now()),
                    ),
                    const SizedBox(height: 20),
                    _buildDataRow('Residence/Tech', state.residenceTech),
                    const SizedBox(height: 20),
                    _buildDataRow(
                      'Technician Note',
                      state.technicianNote,
                      isMultiLine: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Toggle for Breakdown
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Show Cost Breakdown',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Switch(
                      value: _showBreakdown,
                      onChanged: (value) {
                        setState(() {
                          _showBreakdown = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              if (_showBreakdown) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      _buildBreakdownRow('Raw Part Cost', result.rawPartCost),
                      _buildBreakdownRow(
                        'Tax (${(state.taxRate * 100).toStringAsFixed(2)}%)',
                        result.taxAmount,
                      ),
                      _buildBreakdownRow(
                        'Markup Multiplier',
                        result.markupMultiplier,
                        suffix: 'x',
                      ),
                      _buildBreakdownRow(
                        'Customer Part Price',
                        result.customerPartPrice,
                      ),
                      const Divider(),
                      _buildBreakdownRow('Raw Materials', result.rawMaterials),
                      _buildBreakdownRow(
                        'Additional Materials',
                        result.customerMaterialsPrice,
                      ),
                      const Divider(),
                      _buildBreakdownRow('Total Labor', result.totalLabor),
                      _buildBreakdownRow('Travel Fee', result.travelFee),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 40),

              // Email Quote Button (as seen in screenshot)
              ElevatedButton.icon(
                onPressed: () async {
                  final format = NumberFormat.simpleCurrency();

                  final String partsCostStr = format.format(
                    result.customerPartPrice,
                  );
                  final String materialsCostStr = format.format(
                    result.customerMaterialsPrice,
                  );
                  final String laborCostStr = format.format(result.totalLabor);
                  final String travelFeeStr = format.format(result.travelFee);
                  final String totalEstimateStr = format.format(
                    result.totalEstimate,
                  );

                  final subject = 'Zips HVAC Job Estimate';
                  final breakdownText = _showBreakdown
                      ? '''
      ---Cost Breakdown ---
      Raw Part Cost: $partsCostStr
      Additional Materials: $materialsCostStr
      Total Labor: $laborCostStr
      Travel Fee: $travelFeeStr
      
      '''
                      : '';

                  final body =
                      '''
      HVAC CPR Estimate:
      
      Date: ${DateFormat('MM.dd.yyyy').format(DateTime.now())}
      Residence/Tech: ${state.residenceTech}
      Technician Note: ${state.technicianNote}
      
        $breakdownText---
      TOTAL ESTIMATE: $totalEstimateStr
      
      Please let us know if you have any questions.
      ''';

                  final Uri emailLaunchUri = Uri(
                    scheme: 'mailto',
                    path: '',
                    query:
                        'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
                  );

                  try {
                    if (await canLaunchUrl(emailLaunchUri)) {
                      await launchUrl(emailLaunchUri);
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Could not open the email application.',
                            ),
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Could not open the email application.',
                          ),
                        ),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.email_outlined),
                label: const Text('Email Quote'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.background,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, String value, {bool isMultiLine = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildBreakdownRow(String label, double value, {String? suffix}) {
    final format = NumberFormat.simpleCurrency();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(
            suffix != null
                ? '${value.toStringAsFixed(2)}$suffix'
                : format.format(value),
            style: const TextStyle(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
