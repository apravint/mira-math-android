import 'package:flutter/material.dart';

enum MathSubject {
  algebra,
  countingAndProbability,
  geometry,
  intermediateAlgebra,
  numberTheory,
  prealgebra,
  precalculus;

  String get displayName {
    switch (this) {
      case MathSubject.algebra:
        return 'Algebra';
      case MathSubject.countingAndProbability:
        return 'Counting & Probability';
      case MathSubject.geometry:
        return 'Geometry';
      case MathSubject.intermediateAlgebra:
        return 'Intermediate Algebra';
      case MathSubject.numberTheory:
        return 'Number Theory';
      case MathSubject.prealgebra:
        return 'Prealgebra';
      case MathSubject.precalculus:
        return 'Precalculus';
    }
  }

  IconData get icon {
    switch (this) {
      case MathSubject.algebra:
        return Icons.calculate_rounded;
      case MathSubject.countingAndProbability:
        return Icons.casino_rounded;
      case MathSubject.geometry:
        return Icons.change_history_rounded;
      case MathSubject.intermediateAlgebra:
        return Icons.functions_rounded;
      case MathSubject.numberTheory:
        return Icons.tag_rounded;
      case MathSubject.prealgebra:
        return Icons.add_circle_outline_rounded;
      case MathSubject.precalculus:
        return Icons.auto_graph_rounded;
    }
  }

  Color get color {
    switch (this) {
      case MathSubject.algebra:
        return const Color(0xFF00E5FF); // Electric Cyan
      case MathSubject.countingAndProbability:
        return const Color(0xFFFFB300); // Amber
      case MathSubject.geometry:
        return const Color(0xFF10B981); // Emerald
      case MathSubject.intermediateAlgebra:
        return const Color(0xFF8B5CF6); // Violet
      case MathSubject.numberTheory:
        return const Color(0xFFEC4899); // Pink
      case MathSubject.prealgebra:
        return const Color(0xFF3B82F6); // Blue
      case MathSubject.precalculus:
        return const Color(0xFFF97316); // Orange
    }
  }
}

enum MathLevel {
  level1,
  level2,
  level3,
  level4,
  level5;

  String get displayName {
    switch (this) {
      case MathLevel.level1:
        return 'Level 1 (Fundamental)';
      case MathLevel.level2:
        return 'Level 2 (AMC 8/10)';
      case MathLevel.level3:
        return 'Level 3 (AMC 10/12)';
      case MathLevel.level4:
        return 'Level 4 (AIME Tier)';
      case MathLevel.level5:
        return 'Level 5 (Olympiad / USAMO)';
    }
  }

  String get shortName {
    switch (this) {
      case MathLevel.level1:
        return 'L1';
      case MathLevel.level2:
        return 'L2';
      case MathLevel.level3:
        return 'L3';
      case MathLevel.level4:
        return 'L4';
      case MathLevel.level5:
        return 'L5';
    }
  }

  Color get color {
    switch (this) {
      case MathLevel.level1:
        return const Color(0xFF34D399); // Green
      case MathLevel.level2:
        return const Color(0xFF60A5FA); // Sky Blue
      case MathLevel.level3:
        return const Color(0xFFFBBF24); // Yellow
      case MathLevel.level4:
        return const Color(0xFFFB923C); // Orange
      case MathLevel.level5:
        return const Color(0xFFF43F5E); // Crimson Rose
    }
  }
}

class SolutionStep {
  final int stepNumber;
  final String title;
  final String text;
  final String? latex;

  const SolutionStep({
    required this.stepNumber,
    required this.title,
    required this.text,
    this.latex,
  });
}

class MathProblem {
  final String id;
  final MathSubject subject;
  final MathLevel level;
  final String problem;
  final String? hint;
  final List<SolutionStep> solutionSteps;
  final String finalAnswer;
  final String source;

  const MathProblem({
    required this.id,
    required this.subject,
    required this.level,
    required this.problem,
    this.hint,
    required this.solutionSteps,
    required this.finalAnswer,
    this.source = 'OpenAI MATH Dataset',
  });
}
