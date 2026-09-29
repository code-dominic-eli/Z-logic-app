import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/usecases/calculate_estimate.dart';
import '../cubit/calculator_cubit.dart';
import '../cubit/calculator_state.dart';
import 'output_screen.dart';

class InputScreen extends StatelessWidget {
  const InputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CalculatorCubit(CalculateEstimate()),
      child: const _InputScreenContent(),
    );
  }
}

class _InputScreenContent extends StatelessWidget {
  const _InputScreenContent();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              //const ZLogicLogo(size: 32),
              SvgPicture.asset(
                'assets/svg/z_logic_logo.svg',
                height: 32,
                width: 32,
              ),
              const SizedBox(width: 12),
              const Text('Zips HVAC CPR Calculator'),
            ],
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<CalculatorCubit, CalculatorState>(
            builder: (context, state) {
              final cubit = context.read<CalculatorCubit>();

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 26,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Residence/Tech'),
                      CustomTextField(
                        initialValue: state.residenceTech,
                        onChanged: (val) =>
                            cubit.updateField(residenceTech: val),
                        hintText: 'e.g. Smith Residence / Mike',
                      ),
                      _buildError(
                        state.hasAttemptedCalculate &&
                            state.residenceTech.trim().isEmpty,
                        'Residence/Tech is required',
                      ),
                      const SizedBox(height: 16),

                      // Part Cost
                      NumericTextField(
                        label: 'Part Cost (\$)',
                        initialValue: state.partCost,
                        onChanged: (val) => cubit.updateField(partCost: val),
                        hintText: '0.00',
                      ),
                      _buildError(
                        state.hasAttemptedCalculate && state.partCost <= 0,
                        'Part Cost must be greater than 0',
                      ),
                      const SizedBox(height: 16),

                      // Apply Tax Toggle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Apply Tax?',
                            style: TextStyle(color: AppColors.textPrimary),
                          ),
                          Switch(
                            value: state.applyTax,
                            onChanged: (val) {
                              cubit.updateField(applyTax: val);
                              if (val) {
                                cubit.updateField(taxRate: 0.10);
                              }
                            },
                          ),
                        ],
                      ),
                      if (state.applyTax) ...[
                        const SizedBox(height: 8),
                        NumericTextField(
                          label: 'Tax / S&H Rate (%)',
                          initialValue: state.taxRate * 100,
                          onChanged: (val) =>
                              cubit.updateField(taxRate: val / 100),
                          hintText: '10.0',
                        ),
                      ],
                      const SizedBox(height: 16),

                      // Additional Materials
                      NumericTextField(
                        label: 'Additional Materials (\$)',
                        initialValue: state.additionalMaterials,
                        onChanged: (val) =>
                            cubit.updateField(additionalMaterials: val),
                        hintText: '0.00',
                      ),
                      const SizedBox(height: 16),

                      // Markup Materials Toggle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Apply Markup To Materials?',
                            style: TextStyle(color: AppColors.textPrimary),
                          ),
                          Switch(
                            value: state.applyMarkupToMaterials,
                            onChanged: (val) =>
                                cubit.updateField(applyMarkupToMaterials: val),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Labor Hours
                      NumericTextField(
                        label: 'Labor Hours',
                        initialValue: state.laborHours,
                        onChanged: (val) => cubit.updateField(laborHours: val),
                        hintText: '0.0',
                      ),
                      _buildError(
                        state.hasAttemptedCalculate && state.laborHours <= 0,
                        'Labor Hours must be greater than 0',
                      ),
                      const SizedBox(height: 16),

                      // Labor Rate Toggle & Input
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Use default labor rate? (\$200/hr)',
                            style: TextStyle(color: AppColors.textPrimary),
                          ),
                          Switch(
                            value: state.useDefaultLaborRate,
                            onChanged: (val) {
                              cubit.updateField(useDefaultLaborRate: val);
                              if (val) {
                                cubit.updateField(laborRate: 200.0);
                              }
                            },
                          ),
                        ],
                      ),
                      if (!state.useDefaultLaborRate) ...[
                        const SizedBox(height: 8),
                        NumericTextField(
                          label: 'Custom Labor Rate (\$ / Hour)',
                          initialValue: state.laborRate,
                          onChanged: (val) => cubit.updateField(laborRate: val),
                          hintText: '200.00',
                        ),
                        _buildError(
                          state.hasAttemptedCalculate && state.laborRate <= 0,
                          'Labor Rate is required',
                        ),
                      ],
                      const SizedBox(height: 16),

                      // Travel Fee Toggle & Input
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Use default travel fee? (\$100)',
                            style: TextStyle(color: AppColors.textPrimary),
                          ),
                          Switch(
                            value: state.useDefaultTravelFee,
                            onChanged: (val) {
                              cubit.updateField(useDefaultTravelFee: val);
                              if (val) {
                                cubit.updateField(travelFee: 100.0);
                              }
                            },
                          ),
                        ],
                      ),
                      if (!state.useDefaultTravelFee) ...[
                        const SizedBox(height: 8),
                        NumericTextField(
                          label: 'Custom Travel Fee (\$)',
                          initialValue: state.travelFee,
                          onChanged: (val) => cubit.updateField(travelFee: val),
                          hintText: '100.00',
                        ),
                      ],
                      const SizedBox(height: 16),

                      // Technician Note
                      _buildLabel('Technician Note'),
                      CustomTextField(
                        initialValue: state.technicianNote,
                        onChanged: (val) =>
                            cubit.updateField(technicianNote: val),
                        maxLines: 3,
                        hintText: 'Describe the work done...',
                      ),
                      _buildError(
                        state.hasAttemptedCalculate &&
                            state.technicianNote.trim().isEmpty,
                        'Technician Note is required',
                      ),
                      const SizedBox(height: 32),

                      // Calculate Button
                      ElevatedButton.icon(
                        onPressed: () {
                          cubit.attemptCalculate();
                          if (state.isValid) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    OutputScreen(state: state),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.calculate),
                        label: const Text('Calculate'),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: () {
                          cubit.clearForm();
                        },
                        icon: const Icon(Icons.clear),
                        label: const Text('Clear Form'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class NumericTextField extends StatefulWidget {
  final String label;
  final double initialValue;
  final ValueChanged<double> onChanged;
  final String hintText;

  const NumericTextField({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
    required this.hintText,
  });

  @override
  State<NumericTextField> createState() => _NumericTextFieldState();
}

class _NumericTextFieldState extends State<NumericTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialValue == 0 ? '' : widget.initialValue.toString(),
    );
  }

  @override
  void didUpdateWidget(NumericTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only update the controller if the numeric value has actually changed
    // and it's not currently being edited to have a trailing dot or similar.
    final currentValue = double.tryParse(_controller.text) ?? 0.0;
    if (widget.initialValue != currentValue) {
      _controller.text = widget.initialValue == 0
          ? ''
          : widget.initialValue.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(widget.label),
        TextField(
          controller: _controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          ],
          onChanged: (val) {
            final parsed = double.tryParse(val);
            if (parsed != null) {
              widget.onChanged(parsed);
            } else if (val.isEmpty) {
              widget.onChanged(0.0);
            }
          },
          decoration: InputDecoration(hintText: widget.hintText),
          style: const TextStyle(color: AppColors.textPrimary),
        ),
      ],
    );
  }
}

Widget _buildLabel(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(
      text,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

Widget _buildError(bool show, String message) {
  if (!show) return const SizedBox.shrink();
  return Padding(
    padding: const EdgeInsets.only(top: 4.0),
    child: Text(
      message,
      style: const TextStyle(color: Colors.redAccent, fontSize: 12),
    ),
  );
}

class CustomTextField extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;
  final String hintText;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.initialValue,
    required this.onChanged,
    required this.hintText,
    this.maxLines = 1,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != _controller.text) {
      // Find cursor position so it does not reset to start if currently editing
      int cursorPosition = _controller.selection.baseOffset;
      _controller.text = widget.initialValue;
      if (cursorPosition >= 0 && cursorPosition <= _controller.text.length) {
        _controller.selection = TextSelection.collapsed(offset: cursorPosition);
      } else {
        _controller.selection = TextSelection.collapsed(offset: _controller.text.length);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      maxLines: widget.maxLines,
      onChanged: widget.onChanged,
      decoration: InputDecoration(hintText: widget.hintText),
      style: const TextStyle(color: AppColors.textPrimary),
    );
  }
}
