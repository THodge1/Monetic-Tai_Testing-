# Monetic

Monetic is a simple iOS budgeting app for tracking monthly spending in a way that feels lightweight and approachable. Instead of trying to be a full finance platform, the app focuses on the basics: setting a monthly budget, organizing expenses into groups, logging transactions, and seeing how your spending is trending throughout the month.

## What The App Does

The app helps users:

- set a monthly budget
- create and manage spending groups
- add one-time or recurring expenses
- review spending by category
- see a visual overview of monthly spending with charts
- customize app appearance and budget rollover behavior

When the app first launches, users are guided through a short onboarding flow that lets them start with a few default spending groups, then build from there.

## Why It Was Made

Monetic was made to offer a more personal and less overwhelming way to manage day-to-day spending. A lot of budgeting tools feel overly complex, cluttered, or built around features that casual users may not need. This app takes a simpler approach by focusing on the core habit of staying aware of where money is going each month.

The goal is to make budgeting feel easy to start, easy to keep up with, and useful at a glance.

## Framework And Tech Stack

Monetic is built with Apple's modern native iOS tools:

- `SwiftUI` for the user interface and navigation
- `SwiftData` for local data persistence
- `Charts` for spending visualizations
- `AppStorage` for lightweight settings like appearance and monthly budget preferences

The project currently targets `iOS 17.0+`.

## Design System

The interface is built on a single design system rather than SwiftUI defaults. Everything visual is defined in `Monetic/DesignSystem/`:

- `Brand.swift` — colors, surfaces, type scale, radii, and spacing tokens. Every surface is declared once and resolves per interface style.
- `CategoryPalette.swift` — the nine hues a spending group can be tinted with, plus the mapping that resolves color names stored by earlier versions.
- `BrandComponents.swift` — shared cards, buttons, the budget ring, progress bars, the segmented control, and the amount field.

The palette is taken from the app's logo: an electric blue running through violet into magenta, on near-black. The full gradient is reserved for a small number of signature moments — the budget ring, primary buttons, the wordmark, and selection states — so it reads as a brand mark rather than decoration.

Dark is the mode the brand is tuned for and the default for new installs. Light mode is fully supported and can be chosen in Settings.

### Adding the logo asset

`BrandLogoMark` renders `BrandLogo` from the asset catalog when it is present and falls back to a gradient tile when it is not. To use the real logo, add a 1x/2x/3x PNG (or a single vector PDF) to `Monetic/Assets.xcassets/BrandLogo.imageset/`. The app icon is separate — drop a 1024×1024 PNG into `AppIcon.appiconset/`.

## Main Features

- Monthly budget summary with remaining balance and progress tracking
- Expense grouping with custom names, colors, and icons
- Recurring monthly and yearly expense support
- Category detail views for reviewing transactions
- Onboarding flow with starter categories
- Settings for appearance and monthly budget rollover, including a one-tap option to roll last month's budget into the current month

### Budget Rollover

When "Repeat Monthly Budget" is on in Settings, Monetic no longer silently carries the old budget forward. Instead:

- At the start of a new month, the budget prompt leads with a **"Roll Over Last Month's Budget ($X)"** button so the amount carrying forward is explicit, with "Set a Different Amount" as a secondary option.
- A matching **"Roll Over Last Month's Budget"** row appears in Settings any time the current budget differs from the last one recorded, so the amount can be reapplied later even outside the new-month prompt.

With the toggle off, the app still prompts for a new budget each month, offering "Keep Last Month's Budget" as a fallback.

## Running The Project

1. Open `Monetic.xcodeproj` in Xcode.
2. Choose an iPhone simulator or connected device.
3. Build and run the app.

## Status

This is a native iOS app under active development and currently stores data locally on device using SwiftData.

## Built With Claude Code

This project was developed using [Claude Code](https://claude.ai/code) with the following plugins and skills:

### Plugins
- **[everything-claude-code](https://github.com/anthropics/claude-code)** — core skill library providing SwiftUI patterns, feature development workflows, and code review tools
- **[claude-mem](https://github.com/anthropics/claude-code)** — persistent memory across sessions to maintain project context and coding preferences
- **[superpowers](https://github.com/anthropics/claude-code)** — meta-skills for planning, brainstorming, and execution workflows

### Skills Used
- `everything-claude-code:swiftui-patterns` — guidance on SwiftUI layout, state management, and navigation patterns
- `everything-claude-code:feature-dev` — structured workflow for implementing new features
- `everything-claude-code:code-review` — code quality review during development
- `superpowers:brainstorming` — planning app structure and feature design
- `superpowers:executing-plans` — step-by-step implementation of development plans
