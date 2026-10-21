import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/problem.dart';
import '../widgets/glass_card.dart';

class TaxonomyScreen extends StatelessWidget {
  const TaxonomyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          GlassCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00E5FF).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.school_rounded, color: Color(0xFF00E5FF), size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'OpenAI MATH Benchmark',
                            style: GoogleFonts.outfit(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Measuring Mathematical Problem Solving With the MATH Dataset',
                            style: GoogleFonts.outfit(
                              fontSize: 11.5,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  'Published by Dan Hendrycks et al. (UC Berkeley & OpenAI), the MATH benchmark contains 12,500 competition problems designed to test complex mathematical heuristics, multi-step chain-of-thought derivations, and exact theorem application.',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Accuracy Progress Chart across AI Generations
          Text(
            'MATH Benchmark Accuracy Evolution',
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          GlassCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: const [
                _AccuracyBar(model: 'GPT-3 (Hendrycks 2021)', accuracy: 5.2, color: Color(0xFF64748B)),
                SizedBox(height: 12),
                _AccuracyBar(model: 'Minerva 540B (Google 2022)', accuracy: 50.3, color: Color(0xFF3B82F6)),
                SizedBox(height: 12),
                _AccuracyBar(model: 'GPT-4 with CoT (OpenAI 2023)', accuracy: 53.9, color: Color(0xFF8B5CF6)),
                SizedBox(height: 12),
                _AccuracyBar(model: 'Claude 3.5 Sonnet (2024)', accuracy: 71.1, color: Color(0xFF10B981)),
                SizedBox(height: 12),
                _AccuracyBar(model: 'OpenAI o1 / o3 (2025)', accuracy: 83.3, color: Color(0xFF00E5FF)),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 7 Subject Disciplines
          Text(
            '7 Core Subject Disciplines',
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          ...MathSubject.values.map((s) {
            return GlassCard(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: s.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(s.icon, color: s.color, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.displayName,
                          style: GoogleFonts.outfit(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _getSubjectDescription(s),
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  static String _getSubjectDescription(MathSubject s) {
    switch (s) {
      case MathSubject.algebra:
        return 'Quadratic equations, polynomials, inequalities, systems of equations.';
      case MathSubject.countingAndProbability:
        return 'Permutations, combinations, Pigeonhole Principle, expected values.';
      case MathSubject.geometry:
        return 'Euclidean geometry, incircles/circumcircles, coordinate geometry, trigonometry.';
      case MathSubject.intermediateAlgebra:
        return "Vieta's formulas, complex roots, polynomials, sequence recurrence relations.";
      case MathSubject.numberTheory:
        return "Euler's theorem, modular arithmetic, Chinese Remainder Theorem, Diophantine equations.";
      case MathSubject.prealgebra:
        return 'Fractions, ratios, percentage math, prime factorizations, basic coordinates.';
      case MathSubject.precalculus:
        return 'Definite integrals, infinite series summation, limits, trigonometric identities.';
    }
  }
}

class _AccuracyBar extends StatelessWidget {
  final String model;
  final double accuracy;
  final Color color;

  const _AccuracyBar({
    required this.model,
    required this.accuracy,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              model,
              style: GoogleFonts.outfit(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${accuracy.toStringAsFixed(1)}%',
              style: GoogleFonts.firaCode(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: accuracy / 100.0,
            minHeight: 7,
            backgroundColor: Colors.white.withValues(alpha: 0.06),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
