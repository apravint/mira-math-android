# AGENTS.md - Developer & AI Agent Operations Manual for `mira-math-android` 🤖

This document is the definitive operational guide for autonomous AI coding agents (Antigravity, Claude, Cursor, OpenAI Codex, OpenHands) operating within this repository.

---

## 🎯 1. System Overview & Core Philosophy

**Mira Math AI 🧮🤖 (`v1.2.0 - Flutter Edition`)**
> 🌐 Try it Live in Your Browser: [Launch Mira Math AI Flutter Web Edition](https://apravint.github.io/mira-math-android/) Mira Math AI is a high-performance cross-platform Flutter application engineered for solving competition-level mathematical problems based on the landmark OpenAI MATH dataset research paper ("Measuring Mathematical Problem Solving With the MATH Dataset" by Dan Hendrycks et al., UC Berkeley). Fully upgraded to a native Flutter 3.x / Dart 3.x architecture with zero webview overhead, client-side KaTeX mathematical typesetting, hardware-accelerated 60/120fps GPU rendering, and an Impeccable palette-aware glassmorphic design system.

### Key Architectural Capabilities
- **Live LaTeX Preview**: Dynamically typesets mathematical formulas in real-time as you compose.
- **Quick Math Chips**: One-tap insertion of standard LaTeX constructs ($\frac{a}{b}$, $x^2$, $\sqrt{x}$, $\sum$, $\int$, $\binom{n}{k}$, $\lim$, $\pmod{m}$, $\pi$, $\infty$, $\pm$).
- **Chain-of-Thought Derivation Engine**: Decomposes solutions into structured step cards with step numbers, explanations, and rendered formulas.
- **Boxed Final Answer**: Highlights the canonical solution ($\boxed{\text{Answer}}$) with 1-click clipboard copy and native OS sharing.
- **Interactive Practice Mode**: Collapsible hint reveals to guide self-study without spoiling the final answer.
- **Full Derivation Modal**: Interactive bottom sheet displaying the complete step-by-step mathematical proof.

---

## 🏗️ 2. Repository Structure & Directory Map

| Path | Role & Architectural Responsibility |
| :--- | :--- |
| `.github/` | Subsystem directory (.github) |
| `android/` | Native Android Gradle project & wrapper |
| `doc/` | Subsystem directory (doc) |
| `docs/` | Extended documentation, architectural diagrams, guides |
| `ios/` | Native iOS platform harness |
| `lib/` | Flutter / Dart application components & state |
| `linux/` | Subsystem directory (linux) |
| `macos/` | Subsystem directory (macos) |
| `pubspec.yaml` | Flutter / Dart dependency manifest and asset declarations |
| `test/` | Subsystem directory (test) |
| `web/` | Frontend web application interface and assets |
| `windows/` | Subsystem directory (windows) |

---

## ⚙️ 3. Executable Verification Pipeline

Before marking any task complete, an AI agent **must** run the following verification steps sequentially:

### Tier 1: Sound Null-Safety & Static Analysis
```bash
flutter analyze || dart analyze
```

### Tier 2: Automated Unit & Widget Test Suite
```bash
flutter test
```

### Tier 3: Debug Compilation Check
```bash
flutter build apk --debug --no-pub
```

---

## 🛡️ 4. Architectural Invariants & Non-Negotiable Rules

### Strict Invariants ("Never Do" List):
1. **Strict Shell Safety:** Every shell script must declare `set -euo pipefail`. Never use `|| true` on critical installation or backup steps.
2. **Preserve Subshell Exit Codes:** Separate `local` variable declarations from command substitutions (ShellCheck SC2155).
3. **Safe Path Expansion:** Always quote variable expansions (e.g. `"$TARGET_DIR"`) to guard against whitespace and path traversal.

### Security & Environment Variables:
- All API keys and secrets must be loaded strictly from environment variables.
- Never commit `.env`, `.pem`, token files, or private credentials.

---

## 🤖 5. Autonomous Agent Operational Protocol

When dispatched to resolve an issue, implement a feature, or refactor code in this repo:

1. **Phase 1 — Explore & Plan:**
   - Read this `AGENTS.md` and relevant source files.
   - Check existing tests to establish the baseline.
2. **Phase 2 — Act (Surgical Implementation):**
   - Implement changes with minimal blast radius.
   - Adhere to the established code style and existing conventions.
3. **Phase 3 — Verify:**
   - Run the Tier 1, 2, and 3 verification commands listed above.
   - Ensure all existing and new tests pass cleanly.
4. **Phase 4 — Reflect:**
   - Review `git diff` to confirm zero unintended whitespace or collateral changes.
   - Confirm no untracked scratch files remain.

---
*Maintained by Ayyappa Pravin • Engineered for Antigravity, Claude, Cursor & Modern Autonomous AI Agents.*
