import '../entities/calculation_result.dart';

class CalculateEstimate {
  // Markup Table Version A
  // 0.00 - 9.99 = 5.0x
  // 10.00 - 24.99 = 2.5x
  // 25.00 - 99.99 = 2.0x
  // 100.00 - 199.99 = 1.75x
  // 200.00 - 999,999.00 = 1.55x
  double _getMarkupFactor(double cost) {
    if (cost < 0) return 1.0; // Invalid, but fallback
    if (cost < 10.00) return 5.0;
    if (cost < 25.00) return 2.5;
    if (cost < 100.00) return 2.0;
    if (cost < 200.00) return 1.75;
    return 1.55;
  }

  CalculationResult execute({
    required double partCost,
    required bool applyTax,
    required double taxRate, // passed as 0.10 for 10%
    required double additionalMaterials,
    required bool applyMarkupToMaterials,
    required double laborHours,
    required double laborRate,
    required double travelFee,
  }) {
    // 1. Taxed Part
    // If Tax/S&H = Yes: Taxed Part = P x (1 + t)
    // If Tax/S&H = No: Taxed Part = P
    final double taxMultiplier = applyTax ? (1.0 + taxRate) : 1.0;
    final double taxedPartCost = double.parse((partCost * taxMultiplier).toStringAsFixed(2));
    final double taxAmount = applyTax ? double.parse((partCost * taxRate).toStringAsFixed(2)) : 0.0;

    // 2. Customer Part Price
    // Customer Part Price = Taxed Part x m
    final double markupMultiplier = _getMarkupFactor(partCost);
    final double customerPartPrice = double.parse((taxedPartCost * markupMultiplier).toStringAsFixed(2));

    // 3. Additional Materials
    // If MB = ON: Additional Materials = A x m
    // If MB = OFF: Additional Materials = A
    double customerMaterialsPrice = double.parse(additionalMaterials.toStringAsFixed(2));
    if (applyMarkupToMaterials && additionalMaterials > 0) {
      final double materialsMarkup = _getMarkupFactor(additionalMaterials);
      customerMaterialsPrice = double.parse((additionalMaterials * materialsMarkup).toStringAsFixed(2));
    }

    // 4. Labor Total
    final double totalLabor = double.parse((laborHours * laborRate).toStringAsFixed(2));

    // 5. Pre-Total
    final double preTotal = double.parse((customerPartPrice + customerMaterialsPrice + totalLabor + travelFee).toStringAsFixed(2));

    // 6. Total Estimate
    // Rounded to two decimals.
    // In Dart we can just return it, and round it when formatting for display, 
    // but the spec says "Total Estimate = Pre-Total Rounded to two decimals."
    final double totalEstimate = double.parse(preTotal.toStringAsFixed(2));

    return CalculationResult(
      rawPartCost: double.parse(partCost.toStringAsFixed(2)),
      taxAmount: taxAmount,
      taxedPartCost: taxedPartCost,
      markupMultiplier: markupMultiplier,
      customerPartPrice: customerPartPrice,
      rawMaterials: double.parse(additionalMaterials.toStringAsFixed(2)),
      customerMaterialsPrice: customerMaterialsPrice,
      totalLabor: totalLabor,
      travelFee: double.parse(travelFee.toStringAsFixed(2)),
      preTotal: preTotal,
      totalEstimate: totalEstimate,
    );
  }
}
