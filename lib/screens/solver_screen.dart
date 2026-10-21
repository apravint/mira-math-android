import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

import '../models/problem.dart';
import '../services/math_solver.dart';
import '../widgets/glass_card.dart';
import '../widgets/latex_view.dart';
import '../widgets/quick_tokens_bar.dart';
import '../widgets/step_card.dart';

class SolverScreen extends StatefulWidget {
  final String? initialQuery;

  const SolverScreen({super.key, this.initialQuery});

  @override
  State<SolverScreen> createState() => _SolverScreenState();
}

class _SolverScreenState extends State<SolverScreen> {
  late final TextEditingController _inputController;
  MathSubject _selectedSubject = MathSubject.algebra;
  MathLevel _selectedLevel = MathLevel.level4;

  bool _isSolving = false;
  SolverResult? _result;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController(text: widget.initialQuery ?? '');
    _inputController.addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(covariant SolverScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialQuery != null && widget.initialQuery != oldWidget.initialQuery) {
      _inputController.text = widget.initialQuery!;
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _insertToken(String token) {
    final text = _inputController.text;
    final selection = _inputController.selection;
    if (selection.isValid && selection.start >= 0) {
      final newText = text.replaceRange(selection.start, selection.end, token);
      _inputController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: selection.start + token.length),
      );
    } else {
      _inputController.text = text + token;
    }
  }

  void _solve() async {
    final query = _inputController.text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a mathematical equation or problem first.')),
      );
      return;
    }

    HapticFeedback.mediumImpact();
    setState(() => _isSolving = true);

    await Future.delayed(const Duration(milliseconds: 250));

    final res = MathSolverService.solve(
      query: query,
      subject: _selectedSubject,
      level: _selectedLevel,
    );

    setState(() {
      _result = res;
      _isSolving = false;
    });
  }

  void _copyAnswer() {
    if (_result == null) return;
    HapticFeedback.lightImpact();
    Clipboard.setData(ClipboardData(text: _result!.finalAnswer));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Final answer copied to clipboard!')),
    );
  }

  void _shareSolution() {
    if (_result == null) return;
    HapticFeedback.lightImpact();
    final buffer = StringBuffer();
    buffer.writeln('🧮 Mira Math AI Solution');
    buffer.writeln('Subject: ${_result!.subject.displayName} (${_result!.level.displayName})');
    buffer.writeln('Problem: ${_result!.query}\n');
    for (final s in _result!.steps) {
      buffer.writeln('Step ${s.stepNumber} - ${s.title}:');
      buffer.writeln('${s.text}\n');
    }
    buffer.writeln('Final Answer: ${_result!.finalAnswer}');
    // ignore: deprecated_member_use
    Share.share(buffer.toString(), subject: 'Mira Math AI Solution');
  }

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
          // Banner / Intro Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00E5FF), Color(0xFF6366F1)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.psychology_rounded, color: Colors.black, size: 24),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Step-by-Step AI Solver',
                    style: theme.textTheme.headlineMedium?.copyWith(fontSize: 20),
                  ),
                  Text(
                    'OpenAI MATH Chain-of-Thought Reasoning',
                    style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12.5),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Problem Input GlassCard
          GlassCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter Math Expression or LaTeX:',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _inputController,
                  maxLines: 3,
                  style: GoogleFonts.firaCode(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: r'e.g. 3x^2 + 5x - 2 = 0 or \int_{0}^{\pi} x \sin(x) dx',
                    hintStyle: GoogleFonts.firaCode(
                      fontSize: 13,
                      color: isDark ? const Color(0xFF475569) : const Color(0xFF94A3B8),
                    ),
                    filled: true,
                    fillColor: isDark ? const Color(0xFF0A0F1D) : const Color(0xFFF1F5F9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFCBD5E1),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFCBD5E1),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF00E5FF), width: 1.5),
                    ),
                    suffixIcon: _inputController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 20),
                            onPressed: () {
                              _inputController.clear();
                              setState(() => _result = null);
                            },
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 12),

                // Quick Math Tokens Bar
                QuickTokensBar(onTokenSelected: _insertToken),
                const SizedBox(height: 16),

                // Live LaTeX Equation Preview
                if (_inputController.text.trim().isNotEmpty) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0B101D) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LIVE LATEX PREVIEW',
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF00E5FF),
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: LatexView(
                            latex: _inputController.text.trim(),
                            mathStyle: MathStyle.display,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Subject & Difficulty Level Selectors
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Subject',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF0B101D) : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFCBD5E1),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<MathSubject>(
                                value: _selectedSubject,
                                isExpanded: true,
                                icon: const Icon(Icons.arrow_drop_down_rounded),
                                items: MathSubject.values.map((s) {
                                  return DropdownMenuItem(
                                    value: s,
                                    child: Row(
                                      children: [
                                        Icon(s.icon, size: 16, color: s.color),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            s.displayName,
                                            style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w500),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) setState(() => _selectedSubject = val);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Level',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF0B101D) : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFCBD5E1),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<MathLevel>(
                                value: _selectedLevel,
                                isExpanded: true,
                                icon: const Icon(Icons.arrow_drop_down_rounded),
                                items: MathLevel.values.map((lvl) {
                                  return DropdownMenuItem(
                                    value: lvl,
                                    child: Text(
                                      lvl.shortName,
                                      style: GoogleFonts.outfit(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: lvl.color,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) setState(() => _selectedLevel = val);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Solve Action Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isSolving ? null : _solve,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      shadowColor: const Color(0xFF00E5FF).withValues(alpha: 0.3),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00E5FF), Color(0xFF6366F1)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: _isSolving
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.black),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.bolt_rounded, color: Colors.black, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Derive Step-by-Step Solution',
                                    style: GoogleFonts.outfit(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Solution Display Section
          if (_result != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _result!.subject.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _result!.subject.displayName.toUpperCase(),
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _result!.subject.color,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _result!.level.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _result!.level.shortName,
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _result!.level.color,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.copy_rounded, size: 19),
                      tooltip: 'Copy Final Answer',
                      onPressed: _copyAnswer,
                    ),
                    IconButton(
                      icon: const Icon(Icons.share_rounded, size: 19),
                      tooltip: 'Share Solution',
                      onPressed: _shareSolution,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Step by step breakdown cards
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _result!.steps.length,
              itemBuilder: (context, index) {
                return StepCard(step: _result!.steps[index]);
              },
            ),

            // Boxed Final Answer Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF002B36), const Color(0xFF131D33)]
                      : [const Color(0xFFE0F7FA), const Color(0xFFEDE7F6)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF00E5FF).withValues(alpha: 0.6),
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'FINAL BOXED ANSWER',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF00E5FF),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: LatexView(
                      latex: '\\boxed{${_result!.finalAnswer}}',
                      mathStyle: MathStyle.display,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ],
      ),
    );
  }
}
