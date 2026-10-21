# Mira Math AI 🧮🤖 (`v1.2.0 - Flutter Edition`)

[![Flutter Build & Release](https://github.com/apravint/mira-math-android/actions/workflows/build-apk.yml/badge.svg)](https://github.com/apravint/mira-math-android/actions/workflows/build-apk.yml)
[![Live Demo](https://img.shields.io/badge/Live%20Web%20Demo-GitHub%20Pages-00F0FF?style=flat&logo=flutter)](https://apravint.github.io/mira-math-android/)
[![Target SDK](https://img.shields.io/badge/Target%20SDK-35%20(Android%2015)-green.svg)](https://developer.android.com/about/versions/15)
[![Flutter](https://img.shields.io/badge/Flutter-3.47+-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.13+-0175C2.svg)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-purple.svg)](LICENSE)

> 🌐 **Try it Live in Your Browser**: [Launch Mira Math AI Flutter Web Edition](https://apravint.github.io/mira-math-android/)

**Mira Math AI** is a high-performance cross-platform Flutter application engineered for solving competition-level mathematical problems based on the landmark **OpenAI MATH dataset research paper** (*"Measuring Mathematical Problem Solving With the MATH Dataset"* by Dan Hendrycks et al., UC Berkeley). 

Fully upgraded to a native **Flutter 3.x / Dart 3.x** architecture with zero webview overhead, client-side **KaTeX mathematical typesetting**, hardware-accelerated 60/120fps GPU rendering, and an **Impeccable** palette-aware glassmorphic design system.

---

## 🌟 The OpenAI MATH Dataset & Research Alignment

The **OpenAI MATH benchmark** comprises 12,500 challenging competition mathematics problems sourced from AMC 10, AMC 12, AIME, and the USAMO olympiad. Each problem demands multi-step mathematical heuristics and rigorous Chain-of-Thought (CoT) step derivations across 7 core subject disciplines and 5 difficulty levels:

1. 📐 **Algebra** — Quadratic systems, polynomials, inequalities, Vieta's relations.
2. 🎲 **Counting & Probability** — Permutations, combinations, Pigeonhole Principle, expected values.
3. 🔺 **Geometry** — Euclidean proofs, inradius/circumradius theorems, coordinate geometry.
4. 📈 **Intermediate Algebra** — Complex roots, polynomial decomposition, sequence recurrence.
5. 🔢 **Number Theory** — Euler's Totient Theorem, modular congruences, Diophantine equations.
6. ➕ **Prealgebra** — Ratios, prime factorizations, Euclidean GCD algorithms, fractions.
7. 📉 **Precalculus** — Definite integrals by parts, infinite series summation, limits.

---

## 📱 Core Features & Modules

### 1. ⚡ Step-by-Step AI Problem Solver
- Input custom LaTeX expressions or raw math problems.
- **Live LaTeX Preview**: Dynamically typesets mathematical formulas in real-time as you compose.
- **Quick Math Chips**: One-tap insertion of standard LaTeX constructs ($\frac{a}{b}$, $x^2$, $\sqrt{x}$, $\sum$, $\int$, $\binom{n}{k}$, $\lim$, $\pmod{m}$, $\pi$, $\infty$, $\pm$).
- **Chain-of-Thought Derivation Engine**: Decomposes solutions into structured step cards with step numbers, explanations, and rendered formulas.
- **Boxed Final Answer**: Highlights the canonical solution ($\boxed{\text{Answer}}$) with 1-click clipboard copy and native OS sharing.

### 2. 🎯 OpenAI MATH Benchmark Explorer
- Browse authentic competition problems from AMC 10, AMC 12, AIME, and Olympiads.
- Filter on the fly by **7 Subject Disciplines** and **5 Difficulty Tiers** (Level 1 to Level 5).
- **Interactive Practice Mode**: Collapsible hint reveals to guide self-study without spoiling the final answer.
- **Full Derivation Modal**: Interactive bottom sheet displaying the complete step-by-step mathematical proof.
- **Direct Solver Transfer**: "To Solver" button instantly loads any problem into the AI solver for further experimentation.

### 3. ⌨️ Interactive Scientific & LaTeX Keypad
- On-screen mathematical keypad built for fast formula composition without memorizing complex LaTeX syntax.
- Categorized into 4 specialized tabs:
  - **Algebra & Roots**: Variables ($x, y, z, n$), exponents ($x^2, x^n$), fractions ($\frac{a}{b}$), radicals ($\sqrt{x}, \sqrt[n]{x}$).
  - **Calculus & Limits**: Integrals ($\int, \int_a^b$), derivatives ($\frac{d}{dx}, \frac{\partial}{\partial x}$), limits ($\lim_{x \to 0}, \lim_{x \to \infty}$), summations ($\sum$).
  - **Greek & Constants**: $\pi, \theta, \alpha, \beta, \gamma, \delta, \lambda, \mu, \sigma, \Delta, \Sigma, \Omega, \phi$.
  - **Logic & Modular**: Congruences ($\pmod{m}$), binomials ($\binom{n}{k}$), factorials ($n!$), relations ($\le, \ge, \ne, \in, \subset, \implies, \iff$).
- Live formula canvas with backspace, clear, copy, and tactile haptic feedback.

### 4. 📊 OpenAI MATH Taxonomy & Reasoning Evolution
- Comprehensive summary of the Hendrycks et al. research paper.
- Interactive accuracy progress visualizer tracking historical LLM reasoning milestones:
  - GPT-3 (2021): `5.2%`
  - Minerva 540B (2022): `50.3%`
  - GPT-4 with CoT (2023): `53.9%`
  - Claude 3.5 Sonnet (2024): `71.1%`
  - OpenAI o1 / o3 (2025): `83.3%`

---

## 🎨 Impeccable Design System

The UI was crafted adhering to high-end aesthetic guardrails:
- **Midnight Obsidian Dark Theme**: Deep `#090D16` palette tinted with twilight indigo/slate undertones, eliminating dull dead grays.
- **Electric Cyan & Radiant Violet Accents**: Vibrant focal points (`#00E5FF` and `#6366F1`) for primary actions and highlighted formulas.
- **Typography**: Google Fonts [`Outfit`](https://fonts.google.com/specimen/Outfit) for crisp geometric titles and [`Fira Code`](https://fonts.google.com/specimen/Fira+Code) for mathematical notation.
- **Tactile Feedback**: Physics-based light haptics on keypad clicks and token buttons.
- **Android 15 Edge-to-Edge**: Transparent system status and navigation bars with adaptive inset handling.

---

## 🏗️ Project Architecture

```
mira-math-android/
├── lib/
│   ├── data/
│   │   └── math_dataset.dart       # Curated OpenAI MATH competition problem bank
│   ├── models/
│   │   └── problem.dart            # MathProblem, MathSubject, MathLevel, SolutionStep
│   ├── screens/
│   │   ├── benchmark_screen.dart   # Filterable competition problem catalog
│   │   ├── home_screen.dart        # Bottom navigation shell with dynamic theme toggle
│   │   ├── keypad_screen.dart      # Scientific & LaTeX on-screen keyboard builder
│   │   ├── solver_screen.dart      # Chain-of-Thought AI problem solver
│   │   └── taxonomy_screen.dart    # Benchmark accuracy & research overview
│   ├── services/
│   │   └── math_solver.dart        # Mathematical reasoning & heuristic derivation engine
│   ├── theme/
│   │   └── app_theme.dart          # Impeccable Material 3 Dark & Light theme specifications
│   ├── widgets/
│   │   ├── glass_card.dart         # Border-highlighted glassmorphic container
│   │   ├── latex_view.dart         # High-performance flutter_math_fork KaTeX renderer
│   │   ├── quick_tokens_bar.dart   # Horizontal quick-insert math token bar
│   │   └── step_card.dart          # CoT derivation step presentation card
│   └── main.dart                   # Application entrypoint & Edge-to-Edge setup
├── test/
│   └── widget_test.dart            # Smoke tests, solver verification & dataset assertions
├── docs/                           # Compiled Flutter Web release for GitHub Pages
└── .github/workflows/
    └── build-apk.yml               # Automated CI/CD (Test, Analyze, Web Deploy, APK Release)
```

---

## 🚀 Building & Running Locally

### Prerequisites
- [Flutter SDK 3.24+](https://docs.flutter.dev/get-started/install)
- Dart SDK 3.5+
- Android Studio or VS Code with Flutter extension

### 1. Clone & Fetch Dependencies
```bash
git clone https://github.com/apravint/mira-math-android.git
cd mira-math-android
flutter pub get
```

### 2. Run Tests & Code Analysis
```bash
# Verify code quality
flutter analyze

# Execute test suite
flutter test
```

### 3. Run the App
```bash
# Run on connected Android device or emulator
flutter run

# Or launch as Flutter Web in Chrome
flutter run -d chrome
```

### 4. Build Release Artifacts
```bash
# Compile Release Android APK
flutter build apk --release

# Compile Release Web Demo
flutter build web --release --base-href "/mira-math-android/"
```

---

## 📄 License

Created by **Ayyappa Pravin** ([@apravint](https://github.com/apravint)). Open source under the MIT License.
