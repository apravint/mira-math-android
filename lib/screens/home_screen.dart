import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

import 'solver_screen.dart';
import 'benchmark_screen.dart';
import 'keypad_screen.dart';
import 'taxonomy_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const HomeScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String? _solverPreloadText;

  void _navigateToSolverWithText(String text) {
    setState(() {
      _solverPreloadText = text;
      _currentIndex = 0;
    });
  }

  void _shareApp() {
    HapticFeedback.lightImpact();
    // ignore: deprecated_member_use
    Share.share(
      'Check out Mira Math AI - Competition Math Solver & OpenAI MATH Tutor with step-by-step Chain-of-Thought derivations: https://github.com/apravint/mira-math-android',
      subject: 'Mira Math AI Mobile App',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00E5FF), Color(0xFF6366F1)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.calculate_rounded, color: Colors.black, size: 20),
            ),
            const SizedBox(width: 10),
            RichText(
              text: TextSpan(
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onSurface,
                  letterSpacing: -0.3,
                ),
                children: const [
                  TextSpan(text: 'Mira Math '),
                  TextSpan(
                    text: 'AI',
                    style: TextStyle(
                      color: Color(0xFF00E5FF),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF00E5FF).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'v1.2.0',
                style: GoogleFonts.firaCode(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF00E5FF),
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              size: 20,
            ),
            tooltip: 'Toggle Theme',
            onPressed: () {
              HapticFeedback.lightImpact();
              widget.onToggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_rounded, size: 20),
            tooltip: 'Share App',
            onPressed: _shareApp,
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          SolverScreen(
            key: ValueKey(_solverPreloadText),
            initialQuery: _solverPreloadText,
          ),
          BenchmarkScreen(
            onSelectProblemForSolver: _navigateToSolverWithText,
          ),
          KeypadScreen(
            onSendToSolver: _navigateToSolverWithText,
          ),
          const TaxonomyScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          HapticFeedback.selectionClick();
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.psychology_outlined),
            selectedIcon: Icon(Icons.psychology_rounded),
            label: 'AI Solver',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book_rounded),
            label: 'Benchmark',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view_rounded),
            label: 'Keypad',
          ),
          NavigationDestination(
            icon: Icon(Icons.category_outlined),
            selectedIcon: Icon(Icons.category_rounded),
            label: 'Taxonomy',
          ),
        ],
      ),
    );
  }
}
