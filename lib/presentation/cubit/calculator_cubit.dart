import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/calculation_result.dart';
import '../../domain/usecases/calculate_estimate.dart';
import 'calculator_state.dart';

class CalculatorCubit extends Cubit<CalculatorState> {
  final CalculateEstimate _calculateEstimate;

  CalculatorCubit(this._calculateEstimate)
    : super(CalculatorState(result: CalculationResult.empty()));

  void updateField({
    String? residenceTech,
    double? partCost,
    bool? applyTax,
    double? taxRate,
    double? additionalMaterials,
    bool? applyMarkupToMaterials,
    double? laborHours,
    double? laborRate,
    double? travelFee,
    bool? useDefaultLaborRate,
    bool? useDefaultTravelFee,
    String? technicianNote,
    bool? showCostBreakdown,
    bool? hasAttemptedCalculate,
  }) {
    final newState = state.copyWith(
      residenceTech: residenceTech,
      partCost: partCost,
      applyTax: applyTax,
      taxRate: taxRate,
      additionalMaterials: additionalMaterials,
      applyMarkupToMaterials: applyMarkupToMaterials,
      laborHours: laborHours,
      laborRate: laborRate,
      travelFee: travelFee,
      useDefaultLaborRate: useDefaultLaborRate,
      useDefaultTravelFee: useDefaultTravelFee,
      technicianNote: technicianNote,
      showCostBreakdown: showCostBreakdown,
      hasAttemptedCalculate: hasAttemptedCalculate,
    );

    // Recalculate anytime fields change
    final result = _calculateEstimate.execute(
      partCost: newState.partCost,
      applyTax: newState.applyTax,
      taxRate: newState.taxRate,
      additionalMaterials: newState.additionalMaterials,
      applyMarkupToMaterials: newState.applyMarkupToMaterials,
      laborHours: newState.laborHours,
      laborRate: newState.laborRate,
      travelFee: newState.travelFee,
    );

    emit(newState.copyWith(result: result));
  }

  void attemptCalculate() {
    emit(state.copyWith(hasAttemptedCalculate: true));
  }

  void clearForm() {
    emit(CalculatorState(result: CalculationResult.empty()));
  }
}
