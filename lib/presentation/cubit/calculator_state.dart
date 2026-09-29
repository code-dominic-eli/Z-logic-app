import 'package:equatable/equatable.dart';
import '../../domain/entities/calculation_result.dart';

class CalculatorState extends Equatable {
  final String residenceTech;
  final double partCost;
  final bool applyTax;
  final double taxRate;
  final double additionalMaterials;
  final bool applyMarkupToMaterials;
  final double laborHours;
  final double laborRate;
  final double travelFee;
  final String technicianNote;
  final bool showCostBreakdown;

  final bool useDefaultLaborRate;
  final bool useDefaultTravelFee;

  // Validation flags & errors
  final bool hasAttemptedCalculate;

  final CalculationResult result;

  const CalculatorState({
    this.residenceTech = '',
    this.partCost = 0.00,
    this.applyTax = true,
    this.taxRate = 0.10,
    this.additionalMaterials = 0.00,
    this.applyMarkupToMaterials = true,
    this.laborHours = 0.00,
    this.laborRate = 200.00,
    this.travelFee = 100.00,
    this.useDefaultLaborRate = true,
    this.useDefaultTravelFee = true,
    this.technicianNote = '',
    this.showCostBreakdown = false,
    this.hasAttemptedCalculate = false,
    required this.result,
  });

  bool get isValid {
    return residenceTech.trim().isNotEmpty &&
        technicianNote.trim().isNotEmpty &&
        partCost > 0 &&
        laborHours > 0 &&
        (useDefaultLaborRate || laborRate > 0);
  }

  CalculatorState copyWith({
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
    CalculationResult? result,
  }) {
    return CalculatorState(
      residenceTech: residenceTech ?? this.residenceTech,
      partCost: partCost ?? this.partCost,
      applyTax: applyTax ?? this.applyTax,
      taxRate: taxRate ?? this.taxRate,
      additionalMaterials: additionalMaterials ?? this.additionalMaterials,
      applyMarkupToMaterials:
          applyMarkupToMaterials ?? this.applyMarkupToMaterials,
      laborHours: laborHours ?? this.laborHours,
      laborRate: laborRate ?? this.laborRate,
      travelFee: travelFee ?? this.travelFee,
      useDefaultLaborRate: useDefaultLaborRate ?? this.useDefaultLaborRate,
      useDefaultTravelFee: useDefaultTravelFee ?? this.useDefaultTravelFee,
      technicianNote: technicianNote ?? this.technicianNote,
      showCostBreakdown: showCostBreakdown ?? this.showCostBreakdown,
      hasAttemptedCalculate:
          hasAttemptedCalculate ?? this.hasAttemptedCalculate,
      result: result ?? this.result,
    );
  }

  @override
  List<Object?> get props => [
    residenceTech,
    partCost,
    applyTax,
    taxRate,
    additionalMaterials,
    applyMarkupToMaterials,
    laborHours,
    laborRate,
    travelFee,
    useDefaultLaborRate,
    useDefaultTravelFee,
    technicianNote,
    showCostBreakdown,
    hasAttemptedCalculate,
    result,
  ];
}
