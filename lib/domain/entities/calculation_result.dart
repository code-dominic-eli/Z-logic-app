import 'package:equatable/equatable.dart';

class CalculationResult extends Equatable {
  final double rawPartCost;
  final double taxAmount;
  final double taxedPartCost;
  final double markupMultiplier;
  final double customerPartPrice;
  final double rawMaterials;
  final double customerMaterialsPrice;
  final double totalLabor;
  final double travelFee;
  final double preTotal;
  final double totalEstimate;

  const CalculationResult({
    required this.rawPartCost,
    required this.taxAmount,
    required this.taxedPartCost,
    required this.markupMultiplier,
    required this.customerPartPrice,
    required this.rawMaterials,
    required this.customerMaterialsPrice,
    required this.totalLabor,
    required this.travelFee,
    required this.preTotal,
    required this.totalEstimate,
  });

  factory CalculationResult.empty() {
    return const CalculationResult(
      rawPartCost: 0,
      taxAmount: 0,
      taxedPartCost: 0,
      markupMultiplier: 5.0, // Default for 0 is 5.0
      customerPartPrice: 0,
      rawMaterials: 0,
      customerMaterialsPrice: 0,
      totalLabor: 0,
      travelFee: 100, // Developer Constraint: Default travel fee
      preTotal: 100,
      totalEstimate: 100,
    );
  }

  @override
  List<Object?> get props => [
        rawPartCost,
        taxAmount,
        taxedPartCost,
        markupMultiplier,
        customerPartPrice,
        rawMaterials,
        customerMaterialsPrice,
        totalLabor,
        travelFee,
        preTotal,
        totalEstimate,
      ];
}
