# Habits — Product Requirements Document

## 1. Overview

A native iOS habit tracking app with a 3-state logging model:

- **YES** — Full completion (hit your goal)
- **KINDA** — Fallback / minimum effort ("never zero")
- **NO** — Didn't show up

### Core Philosophy

"Never zero" — even small effort counts as momentum. KINDA is not failure; it's showing up.

### Tech Stack

- **Platform:** iOS only
- **Language:** Swift + SwiftUI
- **Persistence:** SwiftData + CloudKit (multi-device sync via user's iCloud)

### Positioning

The best habit tracking app that happens to be free. No aggressive monetization — free core with optional support later.

---

## 2. Goals & Non-Goals

### V1 Goals

1. **Trivially easy** to create habits and log YES/KINDA/NO
2. **Daily habits only** (7×/week) — no complex scheduling
3. **"Never zero"** — KINDA counts as showing up
4. **Clear visual feedback** — GitHub-style history grid, streaks
5. **Polished home screen widget** for glanceable progress
6. **Native feel** — smooth animations, satisfying haptics

### V1 Non-Goals

- No Android or web
- No social features (friends, challenges, leaderboards)
- No AI features
- No complex scheduling (no "3x per week" or custom days)
- No notifications/reminders
- No analytics beyond Apple defaults

---

## 3. Target Users

**Primary user:** The developer (dogfooding first)

**Use cases:**
- Gym / fitness
- Reading
- Spiritual/religious habits
- Deep work / "grind time"
- Sleep, screen time, lifestyle habits

---

## 4. Product Principles

1. **Daily, not perfect** — 7×/week cadence, KINDA counts as showing up
2. **Never zero** — Fallback is momentum, not failure
3. **Frictionless logging** — Tap to log, haptic feedback, no typing during daily use
4. **Visual, not just numerical** — History grids for at-a-glance understanding
5. **Home-grown & respectful** — Free core, optional support, no aggressive monetization
6. **Native feel** — SwiftUI, smooth animations, satisfying haptics

---

## 5. Data Model

### Habit

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | Unique identifier |
| name | String | Habit name |
| createdAt | Date | When habit was created |
| archivedAt | Date? | Soft delete timestamp (nil = active) |
| metricType | Enum | `simple` or `quantitative` |
| unitLabel | String? | For quantitative: "pages", "minutes", etc. |
| goalValue | Double? | For quantitative: target for YES |
| minValue | Double? | For quantitative: minimum for KINDA |
| notes | String? | Optional description of what YES/KINDA mean |

### HabitEntry

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | Unique identifier |
| date | Date | The day (local timezone) |
| state | Enum | `no`, `kinda`, `yes` |
| habit | Habit | Relationship to parent habit |

**Note:** For quantitative habits, thresholds are guidance only. Users manually select YES/KINDA — the app does not auto-calculate state from numbers.

### Computed Values

- **Streak:** Consecutive days with KINDA or YES
- **Consistency (optional):** Fraction of days with KINDA or YES (e.g., "22/30")

---

## 6. User Flows

### 6.1 Onboarding

1. **Intro screens** — Explain YES/KINDA/NO and "never zero" philosophy
2. **First habit creation** — Last intro screen flows directly into creating first habit
3. **Land on home screen** — After creation, show Today view
4. **Encourage more habits** — "Add habit" button has visual pop/animation

### 6.2 Home Screen

Based on mockup (`homemockup.svg`):

```
┌─────────────────────────────────┐
│ habits                          │
│                                 │
│ summary                         │
│ ┌─────────────────────────────┐ │
│ │ habit 1  □□□□□□□□□□■■■■■    │ │
│ │ habit 2  □□□□□□□□□□□■■■■    │ │
│ │ habit 3  □□□□□□□□□□□□■■■    │ │
│ └─────────────────────────────┘ │
│                                 │
│      < Tues, Dec 16th >         │
│                                 │
│ ┌─────────────────────────┐     │
│ │ Habit 1              □  │     │
│ └─────────────────────────┘     │
│ ┌─────────────────────────┐     │
│ │ Habit 2              □  │     │
│ └─────────────────────────┘     │
└─────────────────────────────────┘
```

**Summary Grid:**
- Rows = habits, columns = days
- Cell colors: empty/faint (NO), medium (KINDA), bright (YES)
- **Tap cell** → cycles state for that habit+day (with haptic)
- **Tap habit name** → opens habit detail view

**Date Selector:**
- Shows selected date
- Swipe or arrows to navigate to past days

**Log Cards:**
- One card per habit for selected day
- Alternative way to log (tap to cycle state)

**Past Entries:**
- Editable — users can change past days
- Streak/stats recalculate when history changes

### 6.3 Habit Detail View

Accessed by tapping habit name in summary grid.

**Shows:**
- Full history grid (extended GitHub-style view)
- Current streak count
- Option to archive habit

**Optional:** Consistency fraction (e.g., "22/30 days")

### 6.4 Habit Creation

Triggered from onboarding or "add habit" button.

**Fields:**
- Name (required)
- Metric type toggle: Simple or Quantitative
- If quantitative:
  - Unit label (pages, minutes, etc.)
  - Goal value (what YES means)
  - Min value (what KINDA means)
- Notes (optional)

**UX:** Creative flow TBD during implementation — not a boring form.

### 6.5 Widgets

**V1: Home Screen Widget**
- Summary grid showing recent days across all habits
- Tap opens app
- No in-widget logging

**Post-V1:**
- Lock screen widget (circular progress ring)
- In-widget logging

### 6.6 Archive/Delete

- **Soft delete only** — archiving hides habit from home screen but preserves history
- Archive option lives on habit detail page

---

## 7. Interactions & Feel

- **Tap to log** — Cycles through NO → KINDA → YES → NO
- **Haptic feedback** on every state change
- **Smooth animations** for state transitions
- **No typing during daily logging** — typing only for habit setup

---

## 8. Non-Functional Requirements

- **Performance:** Logging feels instant (<100ms perceived)
- **Reliability:** Local-first — always works offline, syncs when possible
- **Privacy:** No third-party analytics, data lives in user's iCloud only

---

## 9. V1 Scope Summary

### In Scope

- 3-state logging (YES/KINDA/NO)
- Daily habits only
- SwiftData + CloudKit sync
- Onboarding flow
- Home screen (summary grid + log cards)
- Habit detail view (history + streak)
- Quantitative habits (user manually selects state)
- Home screen widget
- Soft delete (archive)
- Haptic feedback
- Smooth animations

### Out of Scope

- Android/web
- Social features
- AI features
- Complex scheduling
- Notifications/reminders
- In-widget logging
- Lock screen widgets
- Settings screen
- "Support the app" flow

---

## 10. Future Backlog

### Post-V1 Features

- Lock screen widget (circular progress ring)
- In-widget logging
- Notifications/reminders
- "Support the app" flow
- Weekly/periodic reviews

### Future Exploration

- Social features (friends, shared habits, challenges)
- AI features (TBD — needs brainstorming)
- Cross-platform (web, Android)

---

## 11. Open Questions

1. **Exact tap interaction** — Tap vs hold to log? Exact cycle order?
2. **Quantitative habit input UX** — How to enter numbers smoothly during setup?
3. **Habit creation flow** — Creative approach TBD during implementation
4. **Visual design** — Colors for NO/KINDA/YES states

---

## Appendix: Reference Files

- `homemockup.svg` — Home screen wireframe
- `original_chatgpt_prd.md` — Initial brainstorm (not authoritative)
