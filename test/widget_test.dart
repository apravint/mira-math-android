import 'package:flutter_test/flutter_test.dart';
import 'package:mira_math_android/main.dart';
import 'package:mira_math_android/data/math_dataset.dart';
import 'package:mira_math_android/models/problem.dart';
import 'package:mira_math_android/services/math_solver.dart';

void main() {
  testWidgets('MiraMathApp renders navigation and header successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const MiraMathApp());
    await tester.pumpAndSettle();

    expect(find.text('AI Solver'), findsWidgets);
    expect(find.text('Benchmark'), findsOneWidget);
    expect(find.text('Keypad'), findsOneWidget);
    expect(find.text('Taxonomy'), findsOneWidget);
  });

  test('Math dataset covers all 7 subjects and has valid solutions', () {
    expect(kMathDataset.isNotEmpty, isTrue);
    final subjects = kMathDataset.map((p) => p.subject).toSet();
    expect(subjects.contains(MathSubject.algebra), isTrue);
    expect(subjects.contains(MathSubject.numberTheory), isTrue);
    expect(subjects.contains(MathSubject.geometry), isTrue);
    expect(subjects.contains(MathSubject.precalculus), isTrue);

    for (final prob in kMathDataset) {
      expect(prob.solutionSteps.isNotEmpty, isTrue);
      expect(prob.finalAnswer.isNotEmpty, isTrue);
    }
  });

  test('MathSolverService solves quadratic formula correctly', () {
    final result = MathSolverService.solve(
      query: '3x^2 + 5x - 2 = 0',
      subject: MathSubject.algebra,
      level: MathLevel.level4,
    );

    expect(result.steps.isNotEmpty, isTrue);
    expect(result.finalAnswer.isNotEmpty, isTrue);
  });
}
