# AGENTS.md - Developer & AI Agent Guide for mira-math-android 🤖

## 🎯 Repository Overview
**mira-math-android**: 🌐 Try it Live in Your Browser: Launch Mira Math AI Flutter Web Edition Mira Math AI is a high-performance cross-platform Flutter application engineered for solving competition-level mathematical problems based on the landmark OpenAI MATH dataset research paper ("Measuring Mathematical Problem Solving With the MATH Dataset" by Dan Hendrycks et al., UC Berkeley).

---

## 🏗️ Repository Architecture
Key directories and entrypoints: `.github/, LICENSE, README.md, analysis_options.yaml, android/, doc/, docs/, index.html, ios/, lib/, linux/, macos/`.

### Tech Stack & Runtime
- **Framework:** Flutter / Dart (Cross-Platform Android, iOS, Web & Desktop)
- **Configuration:** `pubspec.yaml`, `analysis_options.yaml`

## ⚙️ Executable Verification Commands

### 1. Static Analysis & Linting
```bash
flutter analyze || dart analyze
```

### 2. Unit & Widget Tests
```bash
flutter test
```

### 3. Build Verification
```bash
flutter build apk --debug --no-pub
```

---

## 🛡️ Coding & Safety Guidelines for Autonomous Agents

1. **Documentation Integrity:** Preserve all existing docstrings, header comments, and licensing banners. Never delete context unless specifically instructed.
2. **Zero Hardcoded Secrets:** Never embed API keys, OAuth tokens, personal access tokens, or sensitive credentials in committed files. Read credentials exclusively from environment variables or secure credential paths.
3. **Git Hygiene:**
   - Do not force-push (`git push --force`) or execute destructive resets.
   - Never modify root git configurations or harness infrastructure outside task scope.
   - Keep git diffs atomic, focused, and verified before committing.
4. **Agent Workflow Protocol:**
   - **Plan:** Inspect codebase architecture and dependencies before editing.
   - **Act:** Make minimal, clean, high-precision changes.
   - **Verify:** Run the appropriate verification commands listed above.
   - **Reflect:** Confirm zero regressions and review `git diff`.

---
*Maintained by Ayyappa Pravin • Built for Antigravity, Claude, Cursor & Autonomous AI Agents.*
