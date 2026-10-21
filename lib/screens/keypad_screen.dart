import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/latex_view.dart';

class KeypadScreen extends StatefulWidget {
  final ValueChanged<String> onSendToSolver;

  const KeypadScreen({
    super.key,
    required this.onSendToSolver,
  });

  @override
  State<KeypadScreen> createState() => _KeypadScreenState();
}

class _KeypadScreenState extends State<KeypadScreen> with SingleTickerProviderStateMixin {
  String _buffer = r'f(x) = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}';
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _append(String snippet) {
    HapticFeedback.lightImpact();
    setState(() {
      _buffer += snippet;
    });
  }

  void _backspace() {
    HapticFeedback.lightImpact();
    if (_buffer.isNotEmpty) {
      setState(() {
        _buffer = _buffer.substring(0, _buffer.length - 1);
      });
    }
  }

  void _clear() {
    HapticFeedback.mediumImpact();
    setState(() {
      _buffer = '';
    });
  }

  void _copy() {
    HapticFeedback.lightImpact();
    Clipboard.setData(ClipboardData(text: _buffer));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('LaTeX copied to clipboard!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        // Live Formula Composition Canvas (Top)
        Container(
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF101626) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'LIVE FORMULA CANVAS',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF00E5FF),
                      letterSpacing: 1,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.backspace_outlined, size: 18),
                        tooltip: 'Backspace',
                        onPressed: _backspace,
                      ),
                      IconButton(
                        icon: const Icon(Icons.clear_all_rounded, size: 20),
                        tooltip: 'Clear Formula',
                        onPressed: _clear,
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy_rounded, size: 18),
                        tooltip: 'Copy LaTeX',
                        onPressed: _copy,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Rendered KaTeX view
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF090D16) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark ? const Color(0xFF1F293D) : const Color(0xFFE2E8F0),
                  ),
                ),
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: _buffer.isEmpty
                      ? Text(
                          'Formula is empty. Tap keys below to build LaTeX.',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            color: isDark ? const Color(0xFF475569) : const Color(0xFF94A3B8),
                          ),
                        )
                      : LatexView(
                          latex: _buffer,
                          mathStyle: MathStyle.display,
                        ),
                ),
              ),
              const SizedBox(height: 10),

              // Raw LaTeX String preview
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0B101D) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _buffer.isEmpty ? 'raw: [empty]' : 'raw: $_buffer',
                  style: GoogleFonts.firaCode(
                    fontSize: 11.5,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 12),

              // Send to Solver Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.send_rounded, size: 16, color: Colors.black),
                  label: Text(
                    'Load into Step-by-Step Solver',
                    style: GoogleFonts.outfit(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00E5FF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _buffer.trim().isEmpty
                      ? null
                      : () {
                          HapticFeedback.lightImpact();
                          widget.onSendToSolver(_buffer);
                        },
                ),
              ),
            ],
          ),
        ),

        // Keypad Category Tabs
        TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF00E5FF),
          unselectedLabelColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          indicatorColor: const Color(0xFF00E5FF),
          tabs: const [
            Tab(text: 'Algebra'),
            Tab(text: 'Calculus'),
            Tab(text: 'Greek'),
            Tab(text: 'Logic & Mod'),
          ],
        ),

        // Keypad Grid View
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildKeyGrid([
                {'label': 'x', 'val': 'x'},
                {'label': 'y', 'val': 'y'},
                {'label': 'z', 'val': 'z'},
                {'label': 'n', 'val': 'n'},
                {'label': 'a', 'val': 'a'},
                {'label': 'b', 'val': 'b'},
                {'label': '+', 'val': ' + '},
                {'label': '-', 'val': ' - '},
                {'label': '×', 'val': r' \times '},
                {'label': '÷', 'val': r' \div '},
                {'label': '=', 'val': ' = '},
                {'label': '±', 'val': r' \pm '},
                {'label': 'x²', 'val': '^2'},
                {'label': 'xⁿ', 'val': '^{n}'},
                {'label': r'\frac{a}{b}', 'val': r'\frac{a}{b}'},
                {'label': r'\sqrt{x}', 'val': r'\sqrt{x}'},
                {'label': r'\sqrt[n]{x}', 'val': r'\sqrt[n]{x}'},
                {'label': '|x|', 'val': '|x|'},
                {'label': '(', 'val': '('},
                {'label': ')', 'val': ')'},
              ]),
              _buildKeyGrid([
                {'label': '∫', 'val': r'\int '},
                {'label': '∫ₐᵇ', 'val': r'\int_{a}^{b} '},
                {'label': '∑', 'val': r'\sum_{n=1}^{\infty} '},
                {'label': '∏', 'val': r'\prod_{i=1}^{n} '},
                {'label': 'd/dx', 'val': r'\frac{d}{dx} '},
                {'label': '∂/∂x', 'val': r'\frac{\partial}{\partial x} '},
                {'label': 'lim', 'val': r'\lim_{x \to 0} '},
                {'label': 'lim ∞', 'val': r'\lim_{x \to \infty} '},
                {'label': '∞', 'val': r'\infty'},
                {'label': 'e', 'val': 'e'},
                {'label': 'ln', 'val': r'\ln('},
                {'label': 'log', 'val': r'\log_{10}('},
                {'label': 'sin', 'val': r'\sin('},
                {'label': 'cos', 'val': r'\cos('},
                {'label': 'tan', 'val': r'\tan('},
                {'label': 'dx', 'val': ' dx'},
              ]),
              _buildKeyGrid([
                {'label': 'π', 'val': r'\pi'},
                {'label': 'θ', 'val': r'\theta'},
                {'label': 'α', 'val': r'\alpha'},
                {'label': 'β', 'val': r'\beta'},
                {'label': 'γ', 'val': r'\gamma'},
                {'label': 'δ', 'val': r'\delta'},
                {'label': 'λ', 'val': r'\lambda'},
                {'label': 'μ', 'val': r'\mu'},
                {'label': 'σ', 'val': r'\sigma'},
                {'label': 'Δ', 'val': r'\Delta'},
                {'label': 'Σ', 'val': r'\Sigma'},
                {'label': 'Ω', 'val': r'\Omega'},
                {'label': 'ϕ', 'val': r'\phi'},
                {'label': 'ϵ', 'val': r'\epsilon'},
                {'label': 'ω', 'val': r'\omega'},
                {'label': 'ρ', 'val': r'\rho'},
              ]),
              _buildKeyGrid([
                {'label': 'pmod', 'val': r'\pmod{m}'},
                {'label': 'binom', 'val': r'\binom{n}{k}'},
                {'label': 'n!', 'val': '!'},
                {'label': 'gcd', 'val': r'\gcd(a, b)'},
                {'label': '≤', 'val': r' \le '},
                {'label': '≥', 'val': r' \ge '},
                {'label': '≠', 'val': r' \ne '},
                {'label': '≈', 'val': r' \approx '},
                {'label': '∈', 'val': r' \in '},
                {'label': '⊂', 'val': r' \subset '},
                {'label': '∩', 'val': r' \cap '},
                {'label': '∪', 'val': r' \cup '},
                {'label': '∀', 'val': r' \forall '},
                {'label': '∃', 'val': r' \exists '},
                {'label': '⇒', 'val': r' \implies '},
                {'label': '⇔', 'val': r' \iff '},
              ]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKeyGrid(List<Map<String, String>> keys) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.5,
      ),
      itemCount: keys.length,
      itemBuilder: (context, index) {
        final k = keys[index];
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return Material(
          color: isDark ? const Color(0xFF131B2E) : const Color(0xFFE2E8F0),
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => _append(k['val']!),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark ? const Color(0xFF222F47) : const Color(0xFFCBD5E1),
                  width: 0.8,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                k['label']!,
                style: GoogleFonts.firaCode(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
