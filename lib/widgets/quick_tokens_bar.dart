import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class QuickTokensBar extends StatelessWidget {
  final ValueChanged<String> onTokenSelected;

  const QuickTokensBar({
    super.key,
    required this.onTokenSelected,
  });

  static const List<Map<String, String>> _tokens = [
    {'label': r'\frac{a}{b}', 'insert': r'\frac{a}{b}'},
    {'label': 'x²', 'insert': r'x^2'},
    {'label': r'\sqrt{x}', 'insert': r'\sqrt{x}'},
    {'label': '∑', 'insert': r'\sum_{i=1}^{n}'},
    {'label': '∫', 'insert': r'\int_{a}^{b}'},
    {'label': r'\binom{n}{k}', 'insert': r'\binom{n}{k}'},
    {'label': 'lim', 'insert': r'\lim_{x \to \infty}'},
    {'label': 'mod', 'insert': r'\pmod{m}'},
    {'label': 'π', 'insert': r'\pi'},
    {'label': '∞', 'insert': r'\infty'},
    {'label': '±', 'insert': r'\pm'},
    {'label': '≤', 'insert': r'\le'},
    {'label': '≥', 'insert': r'\ge'},
    {'label': 'Δ', 'insert': r'\Delta'},
    {'label': 'θ', 'insert': r'\theta'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _tokens.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final t = _tokens[index];
          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                HapticFeedback.lightImpact();
                onTokenSelected(t['insert']!);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF161F36) : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark ? const Color(0xFF222F47) : const Color(0xFFCBD5E1),
                    width: 0.8,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  t['label']!,
                  style: GoogleFonts.firaCode(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: isDark ? const Color(0xFF00E5FF) : const Color(0xFF0284C7),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
