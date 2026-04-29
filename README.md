<div align="center">

# HostelHop Mobile

Student accommodation discovery, comparison, booking, and payment — built for campus communities.

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](#tech-stack)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](#tech-stack)
[![Status](https://img.shields.io/badge/Status-MVP%20Prototype-F59E0B)](#current-product-stage)
[![Platforms](https://img.shields.io/badge/Platforms-Android%20%7C%20iOS%20%7C%20Linux-111827)](#supported-platforms)
[![License](https://img.shields.io/badge/License-Proprietary-red)](#license)

</div>

HostelHop Mobile is a Flutter app designed to make hostel discovery, comparison, booking, and payment dramatically simpler for students searching for accommodation near campus.

The current codebase is a frontend-first MVP that showcases the product vision with polished screens, mock data, and stubbed user flows, while laying the groundwork for future Supabase-backed backend integration and live payment processing.

## Overview

- Product focus: student housing discovery and booking
- Primary audience: students in mobile-first campus markets
- Current stage: demo-ready MVP / prototype
- Future direction: live listings, persistent bookings, auth, and payments

## Table of Contents

- [Product Vision](#product-vision)
- [Why This Product Matters](#why-this-product-matters)
- [Current Product Stage](#current-product-stage)
- [Core Experience](#core-experience)
- [Feature Snapshot](#feature-snapshot)
- [Screenshots](#screenshots)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Domain Model](#domain-model)
- [Supported Platforms](#supported-platforms)
- [Getting Started](#getting-started)
- [Configuration Notes](#configuration-notes)
- [Roadmap Opportunities](#roadmap-opportunities)
- [Contributing](#contributing)
- [License](#license)

## Product Vision

Finding student accommodation is often fragmented, manual, and stressful. HostelHop aims to improve that experience by giving students a single place to:

- discover hostels near campus
- compare pricing, amenities, and distance
- inspect room availability before reaching out
- reserve a room with less friction
- complete payments through familiar mobile money flows
- manage bookings and profile information in-app

The current sample content is centered around student accommodation in Uganda, making the product direction especially relevant for mobile-first campus markets.

## Why This Product Matters

HostelHop is built around a straightforward value proposition:

| Audience | Value |
|---|---|
| Students | Faster, clearer, less stressful accommodation decisions |
| Hostel operators | Better visibility and a more structured booking funnel |
| Platform | A strong foundation for marketplace, payment, and student-services expansion |

Even in its current form, the app communicates a product story that is easy to demo, validate with users, and extend into a production platform.

## Current Product Stage

This repository currently represents an early MVP / prototype.

### Implemented

- Splash and onboarding experience
- Login and sign-up flows
- Home feed with curated hostel listings
- Explore, bookings, profile, hostel detail, and payment screens
- Mock hostel, room, booking, payment, and student profile data
- Theme persistence with SharedPreferences
- Reusable UI components and organized app structure

### Planned

- Live Supabase authentication
- Real hostel inventory, filtering, and search
- Persistent bookings and user accounts
- Real payment gateway integration
- Notifications and richer account workflows
- Automated test coverage and release hardening

## Core Experience

The current app showcases the main user journey end to end:

1. A new user lands on a branded splash screen
2. Onboarding introduces the product value clearly
3. Authentication screens guide sign-in and sign-up
4. The home experience highlights discoverable hostel inventory
5. Users can inspect hostel details, pricing, and amenities
6. Booking and payment flows simulate a mobile money-style checkout journey
7. Profile and bookings screens establish the basis for account management

## Feature Snapshot

| Area | Current State |
|---|---|
| Authentication | Mocked provider-based sign-in/sign-up flow |
| Listings | Mock hostel inventory with pricing, amenities, and availability |
| Booking | Prototype booking flow driven by local/mock data |
| Payments | Mobile money-inspired payment UI and checkout flow |
| Theme | Light/dark theme support with local persistence |
| Backend | Supabase dependency present, live integration not yet wired |

## Screenshots

No official screenshots are checked into the repository yet, but the README is ready for them.

Suggested screenshot slots:

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

Suggested visual layout once screenshots are available:

| Splash | Onboarding |
|---|---|
| ![Splash screen](assets/screenshots/splash.png) | ![Onboarding flow](assets/screenshots/onboarding.png) |

| Home | Hostel Detail |
|---|---|
| ![Home screen](assets/screenshots/home.png) | ![Hostel detail screen](assets/screenshots/hostel-detail.png) |

| Booking | Payment |
|---|---|
| ![Booking screen](assets/screenshots/booking.png) | ![Payment screen](assets/screenshots/payment.png) |

## Tech Stack

- Flutter
- Dart
- Riverpod for state management (aligned with specs)
- go_router for routing (aligned with specs)
- Supabase for backend (auth, database, storage, real-time)
- Firebase Cloud Messaging for push notifications
- Google Maps Flutter for maps
- Google Places Flutter for place autocomplete
- HTTP client for external APIs (OpenWeatherMap, PesaPal)
- SharedPreferences for local persistence
- Google Fonts
- Smooth Page Indicator
- Cached Network Image
- Flutter Animate

## Project Structure

```text
lib/
├── app.dart
├── main.dart
├── core/
│   ├── constants/
│   ├── services/
│   │   ├── supabase_service.dart
│   │   ├── pesapal_service.dart
│   │   ├── weather_service.dart
│   │   └── fcm_service.dart
│   ├── theme/
│   └── utils/
├── data/
│   ├── mock/
│   └── models/
├── features/
│   ├── auth/
│   ├── hostels/
│   ├── bookings/
│   └── payments/
├── shared/
│   ├── widgets/
│   └── models/
├── screens/
│   ├── auth/
│   ├── booking/
│   ├── explore/
│   ├── home/
│   ├── hostel_detail/
│   ├── onboarding/
│   ├── payment/
│   ├── profile/
│   └── splash/
└── widgets/
```

Structure summary:
- `core/` holds shared services, theme, and utilities
- `data/mock/` powers the current prototype with sample domain data
- `data/models/` contains data models that mirror Supabase schema
- `features/` organizes code by feature using Riverpod (auth, hostels, bookings, payments)
- `shared/` contains reusable widgets and models used across features
- `screens/` organizes feature-level user journeys
- `widgets/` contains reusable building blocks used across the app

## Domain Model

The codebase already defines the main entities needed for a production accommodation platform:

- `Hostel`
- `Room`
- `Booking`
- `Payment`
- `StudentProfile`

These models provide a clean bridge from prototype UI to future backend-backed features.

## Supported Platforms

This repository includes Flutter scaffolding for:
- Android
- iOS
- Linux

The product direction is clearly mobile-first, while Linux support is useful for development and local testing.

## Getting Started

### Prerequisites

Install the following:
- Flutter SDK
- Dart SDK
- Android Studio and/or Xcode depending on target platform
- A simulator, emulator, or physical device

Check your setup:

```bash
flutter doctor
```

### Install dependencies

```bash
flutter pub get
```

### Run the app

```bash
flutter run
```

To target a specific device:

```bash
flutter devices
flutter run -d <device_id>
```

### Analyze the codebase

```bash
flutter analyze
```

## Configuration Notes

The current mock-driven version does not require secrets or backend credentials.

A production-ready version will likely require configuration for:
- Supabase project URL
- Supabase anon key
- payment provider credentials
- environment-specific app settings

## Roadmap Opportunities

Potential next milestones for the product:

1. Integrate real authentication with Supabase
2. Replace mock inventory with live hostel and room data
3. Add search, filters, and sorting for discovery
4. Implement persistent booking lifecycle management
5. Connect real payment flows and payment status tracking
6. Add notifications, analytics, and release readiness checks
7. Expand toward a stronger student housing marketplace experience

## Contributing

Contribution guidance is available in `CONTRIBUTING.md`.

## License

This project is proprietary and not licensed for public reuse, modification, or distribution. See `LICENSE` for details.
