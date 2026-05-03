# Contributing to HostelHop Mobile

Thanks for contributing to HostelHop Mobile.

This repository is currently maintained as a proprietary product codebase. Contributions should align with the product direction, coding standards, and review expectations described below.

## Before You Start

Before making changes:

- confirm the task or feature scope with the maintainers
- check for related product, UI, or backend assumptions
- keep changes focused and easy to review
- avoid introducing speculative features that are not yet needed

## Development Setup

### Prerequisites

Install:

- Flutter SDK
- Dart SDK
- Android Studio and/or Xcode depending on your target platform
- a device emulator, simulator, or physical device

Verify your environment:

```bash
flutter doctor
```

Install dependencies:

```bash
flutter pub get
```

Run the app:

```bash
flutter run
```

Analyze the codebase:

```bash
flutter analyze
```

## Project Conventions

### General Principles

- prefer small, focused pull requests
- preserve the current app structure unless there is a strong reason to change it
- keep UI code readable and composable
- prefer reusable widgets over repeated layout blocks
- keep business logic out of screen widgets when possible
- document non-obvious decisions in code comments or PR notes

### State Management

The project currently uses Provider.

When adding stateful behavior:

- place shared app state in `lib/providers/`
- keep provider responsibilities narrow and easy to test
- avoid putting unrelated concerns into a single provider

### Data and Domain Modeling

The current version uses mock data.

When changing models or mock flows:

- keep domain models in `lib/data/models/`
- keep mock data isolated under `lib/data/mock/`
- design changes so they can transition cleanly to future Supabase-backed services

### Routing and Navigation

- keep navigation flows consistent and predictable
- avoid scattered route string duplication where possible
- if routing becomes more complex, prefer consolidating behavior around the existing routing utilities in `lib/core/routing/`

### Theming and Design

- respect the existing HostelHop visual language
- use shared theme, typography, and color primitives from `lib/core/theme/`
- avoid hardcoding styles when a shared token or theme value is more appropriate

## Branching and Commits

Recommended workflow:

1. create a feature branch from `main`
2. make a focused set of changes
3. run analysis and manual verification
4. open a pull request with a clear summary

Example branch names:

- `feature/payment-flow-improvements`
- `fix/login-validation`
- `docs/readme-refresh`

Example commit styles:

- `feat: add hostel detail booking CTA`
- `fix: correct theme persistence behavior`
- `docs: improve contributor setup instructions`

## Quality Checklist

Before submitting changes, make sure you:

- run `flutter pub get` if dependencies changed
- run `flutter analyze`
- manually test any affected screens or flows
- verify navigation still works as expected
- verify light/dark theme behavior if UI was changed
- keep generated files and local build artifacts out of commits unless intentionally required

## Pull Request Expectations

A good pull request should include:

- a concise description of what changed
- the reason for the change
- any relevant screenshots for UI updates
- notes on manual testing performed
- any follow-up work that remains

Suggested PR template content:

```md
## Summary
- 

## Why
- 

## Screenshots
- 

## Testing
- [ ] flutter analyze
- [ ] manual app run
- [ ] affected flow tested

## Follow-up
- 
```

## Screenshots for UI Changes

For visual changes, include before/after screenshots where possible.

Suggested screenshot paths for repo documentation:

```text
assets/screenshots/
├── splash.png
├── onboarding.png
├── login.png
├── home.png
├── hostel-detail.png
├── booking.png
├── payment.png
└── profile.png
```

## Areas That Need Extra Care

Be especially careful when modifying:

- authentication flows
- payment-related screens and messaging
- shared theme definitions
- core models that may later map to backend tables
- navigation entry points and route handling

## Code Review Guidance

Reviewers will generally look for:

- product clarity
- UI consistency
- maintainable structure
- minimal unnecessary complexity
- readiness for future backend integration

## Security and Confidentiality

Because this is a proprietary repository:

- do not publish code, screenshots, or internal product details externally without permission
- do not add secrets, tokens, or credentials to source control
- use environment-specific configuration for sensitive values when backend integration is added

## Questions

If requirements are unclear, ask before implementing large changes. It is better to align early than to rewrite later.
