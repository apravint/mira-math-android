import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/math_dataset.dart';
import '../models/problem.dart';
import '../widgets/glass_card.dart';
import '../widgets/latex_view.dart';
import '../widgets/step_card.dart';

class BenchmarkScreen extends StatefulWidget {
  final ValueChanged<String> onSelectProblemForSolver;

  const BenchmarkScreen({
    super.key,
    required this.onSelectProblemForSolver,
  });

  @override
  State<BenchmarkScreen> createState() => _BenchmarkScreenState();
}

class _BenchmarkScreenState extends State<BenchmarkScreen> {
  MathSubject? _filterSubject;
  MathLevel? _filterLevel;
  final Set<String> _revealedHints = {};

  List<MathProblem> get _filteredProblems {
    return kMathDataset.where((p) {
      if (_filterSubject != null && p.subject != _filterSubject) return false;
      if (_filterLevel != null && p.level != _filterLevel) return false;
      return true;
    }).toList();
  }

  void _showSolutionModal(BuildContext context, MathProblem problem) {
    HapticFeedback.lightImpact();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F1523) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFCBD5E1),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              // Bottom Sheet Grab Handle
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),

              // Title Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: problem.subject.color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            problem.subject.displayName,
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: problem.subject.color,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: problem.level.color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            problem.level.shortName,
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: problem.level.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(),

              // Solution Steps Content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Text(
                      'Competition Problem',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF00E5FF),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      problem.problem,
                      style: GoogleFonts.outfit(fontSize: 14.5, height: 1.45),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Step-by-Step Derivation',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF00E5FF),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...problem.solutionSteps.map((s) => StepCard(step: s)),
                    const SizedBox(height: 14),

                    // Boxed Answer
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDark
                              ? [const Color(0xFF002B36), const Color(0xFF131D33)]
                              : [const Color(0xFFE0F7FA), const Color(0xFFEDE7F6)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF00E5FF).withValues(alpha: 0.5),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'BOXED FINAL ANSWER',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF00E5FF),
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          LatexView(latex: '\\boxed{${problem.finalAnswer}}'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final problems = _filteredProblems;

    return Column(
      children: [
        // Subject Filter Bar (Horizontal)
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    FilterChip(
                      selected: _filterSubject == null,
                      label: const Text('All Subjects'),
                      onSelected: (_) => setState(() => _filterSubject = null),
                    ),
                    const SizedBox(width: 8),
                    ...MathSubject.values.map((s) {
                      final isSel = _filterSubject == s;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          selected: isSel,
                          avatar: Icon(s.icon, size: 14, color: isSel ? Colors.black : s.color),
                          label: Text(s.displayName),
                          onSelected: (_) {
                            setState(() {
                              _filterSubject = isSel ? null : s;
                            });
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Level Filter Bar
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    FilterChip(
                      selected: _filterLevel == null,
                      label: const Text('All Levels'),
                      onSelected: (_) => setState(() => _filterLevel = null),
                    ),
                    const SizedBox(width: 8),
                    ...MathLevel.values.map((lvl) {
                      final isSel = _filterLevel == lvl;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          selected: isSel,
                          label: Text(lvl.shortName),
                          labelStyle: TextStyle(
                            color: isSel ? Colors.black : lvl.color,
                            fontWeight: FontWeight.bold,
                          ),
                          onSelected: (_) {
                            setState(() {
                              _filterLevel = isSel ? null : lvl;
                            });
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // Problems List
        Expanded(
          child: problems.isEmpty
              ? Center(
                  child: Text(
                    'No problems match the selected filters.',
                    style: theme.textTheme.bodyMedium,
                  ),
                )
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: problems.length,
                  itemBuilder: (context, index) {
                    final p = problems[index];
                    final hasHint = p.hint != null;
                    final isHintRevealed = _revealedHints.contains(p.id);

                    return GlassCard(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top info: Source, Subject, Level
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                p.source,
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: p.subject.color.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      p.subject.displayName,
                                      style: GoogleFonts.outfit(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: p.subject.color,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: p.level.color.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      p.level.shortName,
                                      style: GoogleFonts.outfit(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: p.level.color,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Problem Statement
                          Text(
                            p.problem,
                            style: GoogleFonts.outfit(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onSurface,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Collapsible Hint Section
                          if (hasHint) ...[
                            if (isHintRevealed)
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFB300).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(0xFFFFB300).withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.lightbulb_rounded, size: 18, color: Color(0xFFFFB300)),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        p.hint!,
                                        style: GoogleFonts.outfit(
                                          fontSize: 12.5,
                                          color: isDark ? const Color(0xFFFDE68A) : const Color(0xFF92400E),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],

                          // Action Buttons Row
                          Row(
                            children: [
                              if (hasHint)
                                TextButton.icon(
                                  icon: Icon(
                                    isHintRevealed ? Icons.lightbulb_outline : Icons.lightbulb_rounded,
                                    size: 16,
                                  ),
                                  label: Text(isHintRevealed ? 'Hide Hint' : 'Hint'),
                                  style: TextButton.styleFrom(
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  onPressed: () {
                                    HapticFeedback.selectionClick();
                                    setState(() {
                                      if (isHintRevealed) {
                                        _revealedHints.remove(p.id);
                                      } else {
                                        _revealedHints.add(p.id);
                                      }
                                    });
                                  },
                                ),
                              const Spacer(),
                              OutlinedButton.icon(
                                icon: const Icon(Icons.code_rounded, size: 16),
                                label: const Text('To Solver'),
                                style: OutlinedButton.styleFrom(
                                  visualDensity: VisualDensity.compact,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  widget.onSelectProblemForSolver(p.problem);
                                },
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.visibility_rounded, size: 16),
                                label: const Text('Derivation'),
                                style: ElevatedButton.styleFrom(
                                  visualDensity: VisualDensity.compact,
                                  backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFF0F172A),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () => _showSolutionModal(context, p),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
