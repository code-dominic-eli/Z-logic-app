import 'package:flutter_test/flutter_test.dart';
import 'package:z_logic/domain/usecases/calculate_estimate.dart';

void main() {
  final calculator = CalculateEstimate();

  group('Markup Table Version A Tests', () {
    test('Markup 5.0x for cost 5.00', () {
      final result = calculator.execute(
        partCost: 5.00,
        applyTax: false,
        taxRate: 0.1,
        additionalMaterials: 0,
        applyMarkupToMaterials: false,
        laborHours: 0,
        laborRate: 200,
        travelFee: 0,
      );
      // P=5, tax=N -> Taxed Part=5. Customer Part Price=5*5.0=25.
      expect(result.customerPartPrice, 25.0);
    });

    test('Markup 2.5x for cost 15.00', () {
      final result = calculator.execute(
        partCost: 15.00,
        applyTax: false,
        taxRate: 0.1,
        additionalMaterials: 0,
        applyMarkupToMaterials: false,
        laborHours: 0,
        laborRate: 200,
        travelFee: 0,
      );
      // P=15 -> m=2.5. Customer Part Price=15*2.5=37.5.
      expect(result.customerPartPrice, 37.5);
    });

    test('Markup 2.0x for cost 50.00', () {
      final result = calculator.execute(
        partCost: 50.00,
        applyTax: false,
        taxRate: 0.1,
        additionalMaterials: 0,
        applyMarkupToMaterials: false,
        laborHours: 0,
        laborRate: 200,
        travelFee: 0,
      );
      // P=50 -> m=2.0. Price=100.
      expect(result.customerPartPrice, 100.0);
    });

    test('Markup 1.75x for cost 150.00', () {
      final result = calculator.execute(
        partCost: 150.00,
        applyTax: false,
        taxRate: 0.1,
        additionalMaterials: 0,
        applyMarkupToMaterials: false,
        laborHours: 0,
        laborRate: 200,
        travelFee: 0,
      );
      // P=150 -> m=1.75. Price=262.5.
      expect(result.customerPartPrice, 262.5);
    });

    test('Markup 1.55x for cost 300.00', () {
      final result = calculator.execute(
        partCost: 300.00,
        applyTax: false,
        taxRate: 0.1,
        additionalMaterials: 0,
        applyMarkupToMaterials: false,
        laborHours: 0,
        laborRate: 200,
        travelFee: 0,
      );
      // P=300 -> m=1.55. Price=465.0.
      expect(result.customerPartPrice, 465.0);
    });
    group('Specific Logic Rules', () {
    test('Tax applied before markup', () {
       // P=100, tax=Y(10%) -> Taxed Part=110.
       // Markup for 110 is 1.75x (100-199 range).
       // Customer Part Price = 110 * 1.75 = 192.5
       final result = calculator.execute(
        partCost: 100.00,
        applyTax: true,
        taxRate: 0.10,
        additionalMaterials: 0,
        applyMarkupToMaterials: false,
        laborHours: 0,
        laborRate: 200,
        travelFee: 0,
      );
      expect(result.customerPartPrice, 192.5);
    });
    
    test('Total Estimate Summation', () {
      // P=200, tax=N -> Taxed Part=200. m=1.55. Customer Price=310.
      // A=100, MB=ON -> m=1.75. Customer Materials=175.
      // H=2, R=200 -> Labor=400.
      // F=100.
      // Total = 310 + 175 + 400 + 100 = 985.
      final result = calculator.execute(
        partCost: 200.00,
        applyTax: false,
        taxRate: 0.1,
        additionalMaterials: 100,
        applyMarkupToMaterials: true,
        laborHours: 2.0,
        laborRate: 200,
        travelFee: 100,
      );
      expect(result.totalEstimate, 985.0);
    });

    test('Tax only applies to Part, not Labor or Travel', () {
      // P=100, tax=Y(10%) -> Taxed Part=110.
      // H=1, R=100 -> Labor=100.
      // F=50.
      // Markup for 110 is 1.75x -> Customer Price=192.5
      // Total = 192.5 + 100 + 50 = 342.5
      final result = calculator.execute(
        partCost: 100.00,
        applyTax: true,
        taxRate: 0.10,
        additionalMaterials: 0,
        applyMarkupToMaterials: false,
        laborHours: 1.0,
        laborRate: 100,
        travelFee: 50,
      );
      expect(result.customerPartPrice, 192.5);
      expect(result.totalEstimate, 342.5);
    });
  });
});
}
