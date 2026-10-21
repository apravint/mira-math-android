import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:google_fonts/google_fonts.dart';

export 'package:flutter_math_fork/flutter_math.dart' show MathStyle;

class LatexView extends StatelessWidget {
  final String latex;
  final TextStyle? textStyle;
  final MathStyle mathStyle;
  final bool selectable;
  final Color? color;

  const LatexView({
    super.key,
    required this.latex,
    this.textStyle,
    this.mathStyle = MathStyle.display,
    this.selectable = true,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.onSurface;

    try {
      if (selectable) {
        return SelectableMath.tex(
          latex,
          mathStyle: mathStyle,
          textStyle: (textStyle ?? theme.textTheme.bodyMedium)?.copyWith(
            color: effectiveColor,
            fontSize: mathStyle == MathStyle.display ? 17 : 14,
          ),
          onErrorFallback: (err) => _buildFallback(latex, effectiveColor),
        );
      } else {
        return Math.tex(
          latex,
          mathStyle: mathStyle,
          textStyle: (textStyle ?? theme.textTheme.bodyMedium)?.copyWith(
            color: effectiveColor,
            fontSize: mathStyle == MathStyle.display ? 17 : 14,
          ),
          onErrorFallback: (err) => _buildFallback(latex, effectiveColor),
        );
      }
    } catch (_) {
      return _buildFallback(latex, effectiveColor);
    }
  }

  Widget _buildFallback(String raw, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        raw,
        style: GoogleFonts.firaCode(
          fontSize: 13,
          color: textColor.withValues(alpha: 0.9),
        ),
      ),
    );
  }
}
