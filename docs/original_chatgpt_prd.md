# Daily Habits App – Product Requirements Document (PRD)

## 1. Overview

A **native iOS habit app** focused on **daily (7×/week) touchpoints** with a 3-state model:

- **YES** – full completion (hit your goal).
- **KINDA** – fallback / minimum effort (“never zero”).
- **NO** – didn’t show up.

The app is:

- **iOS-only**, built with **Swift + SwiftUI**.
- Uses **SwiftData + CloudKit** as the data + sync layer (no custom backend).
- Designed as a **community-service, home-grown** project: free core, optionally supportable.

Core UX pillars:

- Ultra-low friction logging (taps, haptics, smooth animations).
- Visual tracking via **GitHub-style / calendar-style history**.
- Strong **widget** story so users can see progress without opening the app.

---

## 2. Goals & Non-Goals

### 2.1 Primary Goals (V1)

- Make it **trivially easy** to:
  - Create daily habits with clear goals and fallback minimums.
  - Log **NO / KINDA / YES** for each day and each habit.
- Anchor the product philosophy around:
  - **Daily reps (7× per week)** as the default cadence.
  - **“Never zero”** – small effort still counts as momentum.
- Provide **clear visual feedback**:
  - Per-habit history across days.
  - A simple way to understand “how I’ve been doing lately”.
- Ship with **useful, polished widgets** so users see progress at a glance.

### 2.2 Non-Goals (for V1)

- No multi-platform support (no web, Android).
- No social features (friends, shared habits, challenges).
- No AI features (AI-generated notifications, habit suggestions).
- No complex scheduling (no “3x per week”, no custom weekdays).
- No analytics/telemetry beyond what Xcode/Apple gives by default.

---

## 3. Target Users & Use Cases

### 3.1 Users

- Anyone who wants to **build or maintain habits**, regardless of background.
- Example uses:
  - Fitness (gym, daily movement).
  - Reading.
  - Spiritual/religious habits (e.g. prayer, journaling) – but app is **not** faith-specific.
  - Deep work / “grind time”.
  - Lifestyle habits (sleep, screen time, etc.).

### 3.2 Core Use Cases

1. **Create a new habit**
   - Define what “YES” and “KINDA” mean.
   - Optionally define a **metric** (pages, minutes, sets, etc.).
2. **Log today**
   - Open app or widget → mark each habit as NO / KINDA / YES for today.
3. **Review recent performance**
   - Answer “How have I been doing over the last few weeks?” per habit.
4. **Glanceable progress**
   - Use widgets to see day streaks and recent momentum without opening the app.

---

## 4. Product Principles

1. **Daily, not perfect**
   - Cadence is anchored at **7× per week**. Even KINDA counts as “I showed up.”
2. **Never zero**
   - The fallback state is first-class – it’s not failure, it’s momentum.
3. **Frictionless logging**
   - No typing, no sliders in V1. Just clear taps and satisfying feedback.
4. **Visual, not just numerical**
   - Visual history maps make behavior emotionally understandable at a glance.
5. **Home-grown & respectful**
   - Community feel; no aggressive monetization; optional support only.
6. **Native feel**
   - SwiftUI, smooth transitions, haptics, and thoughtful micro-interactions.

---

## 5. Core Concepts & Data Model (Conceptual)

> This is conceptual; actual SwiftData models will implement this structure.

### 5.1 Entities

#### Habit

- `id: UUID`
- `name: String`
- `createdAt: Date`
- `archivedAt: Date?` (for hiding habits while preserving history)
- `metricType: HabitMetricType`
  - `simple` – no explicit numeric metric (just NO/KINDA/YES).
  - `quantitative` – uses goal/min/unit.
- `unitLabel: String?`
  - e.g., `"pages"`, `"minutes"`, `"sets"`.
- `goalValue: Double?`
  - Target amount for a full YES (quantitative only).
- `minValue: Double?`
  - Minimum amount for KINDA (must be `< goalValue` when both set).
- `notes: String?`
  - Optional description of what YES vs KINDA means.
- Relationship:
  - `entries: [HabitEntry]`

#### HabitEntry

> One per habit per day.

- `id: UUID`
- `date: Date` (treated as a “day”; local timezone semantics)
- `state: HabitState`
  - `none` (NO)
  - `kinda`
  - `yes`
- Relationship:
  - `habit: Habit`

#### HabitState (enum)

- `none` → 0
- `kinda` → 1
- `yes` → 2

#### HabitMetricType (enum)

- `simple`
- `quantitative`

### 5.2 Computed Concepts

- **Daily streak (per habit)**
  - Count of consecutive days with state `kinda` or `yes`.
- **Consistency (per habit)**
  - E.g., last 7 or 30 days: proportion of days with `kinda` or `yes`.
- **Day “score” (across habits)**
  - Map states to numerical values (e.g., 0 / 0.5 / 1), average across habits for that day.

---

## 6. V1 Scope – Functional Requirements

### 6.1 Platform & Tech

- iOS app built in **Swift + SwiftUI**.
- Persistence: **SwiftData**.
- Sync: **SwiftData + CloudKit** (user’s data in their own iCloud; no custom backend).
- iOS **widgets** using WidgetKit.

---

### 6.2 User Flows

#### 6.2.1 Onboarding

**Goal:** Guide user to create their first habit and log today, with a memorable experience.

**Requirements:**

- Intro screens (max 2–3):
  - Explain philosophy:
    - Daily touchpoints (7× per week).
    - YES / KINDA / NO and the idea of “never zero”.
- Guided first habit creation:
  - Prompt to “Create your first habit”.
  - Wizard style (multiple small steps, not one huge form).
- Post-creation:
  - Take user directly to **today’s logging view** with that habit.
  - Encourage first check-in with YES or KINDA.
  - Provide haptic + visual confirmation.

#### 6.2.2 Create Habit

**Requirements:**

- Fields:
  - Name (required).
  - Metric toggle:
    - Simple habit (no numbers).
    - Quantitative habit:
      - Unit label (from presets + custom).
      - Goal value (required for quantitative).
      - Minimum value (optional but recommended; must be `< goal` if set).
  - Optional notes (“What does YES mean? What does KINDA mean?”).
- When user picks quantitative:
  - Show suggestions (e.g., “Reading: goal 10 pages, min 1 page”).
- Validation:
  - For quantitative:
    - `goalValue` > 0.
    - If `minValue` exists, `0 < minValue < goalValue`.
- Editing:
  - User can edit an existing habit (name, unit, goals) any time.
  - Editing does **not** alter past entries; it only affects interpretation going forward.

#### 6.2.3 Today View (Primary Screen)

**Goal:** Make logging today’s habits trivial and satisfying.

**Layout (high-level):**

- **Top section: “Today”**
  - Date (with left/right swipe or arrow buttons to move between days).
  - Vertical list of habits.
- Habit row:
  - Habit name.
  - 3-state control:
    - Tap cycling through:
      - NO → YES → KINDA → NO
      - or NO → KINDA → YES → NO  
      (exact mapping to be decided, but must be consistent and intuitive).
  - Optional micro indicator: small icon or bar for streak or recent consistency.

**Behavior:**

- Tapping state:
  - Updates `HabitEntry` for that habit + day (create if missing).
  - Animates visually (color change, subtle scale).
  - Triggers haptic feedback.
- Navigating days:
  - User can view and edit past days by shifting the day context.
  - No hard limit initially (can backfill as needed).
  - Future: consider constraints if needed.

#### 6.2.4 History / Overview

**Goal:** Let users understand how they’ve been doing over time, primarily per habit.

**V1 requirements:**

- **Per-habit history view:**
  - For a selected habit:
    - Show a simple visual history for at least the last **6–12 weeks**.
    - Representation:
      - Calendar/grid or GitHub-style layout.
      - Each day colored by `state`:
        - NO → faint / empty.
        - KINDA → medium.
        - YES → bright.
- **Summary stats (per habit):**
  - Current streak length.
  - 7-day consistency (days with KINDA/YES / total).
  - Optional: 30-day consistency.

**Implementation note:**  
Layout specifics (bottom ribbon vs separate tab) can evolve. The requirement is the **functionality**: per-habit visual history + basic streak/consistency numbers.

#### 6.2.5 Widgets (Home Screen)

**Goal:** Let users **see progress without opening the app**; logging can be deep-linked initially.

**V1 widgets:**

1. **Overall Momentum Widget (GitHub-style)**
   - Size: small or medium.
   - Shows an **aggregate grid** of the last ~28–42 days.
   - Each day’s brightness based on the **day score** across all habits.
   - Tap → opens app at **Today view**.

2. **Today Summary Widget**
   - Size: small or medium.
   - Shows:
     - Today’s date.
     - Count or ratio of YES / KINDA / NO for today.
     - Optional mini 7-day strip.

**Interaction:**

- V1: **taps deep-link into app** (no in-widget state changes).
- Later (V2+): interactive logging inside the widget.

#### 6.2.6 Data & Sync

**Requirements:**

- **Local persistence** via SwiftData.
- **Cloud sync** via CloudKit:
  - User data tied to their Apple ID.
  - Multi-device support (iPhone + iPad on same Apple ID).
- Behavior on new devices:
  - If user signs in with same Apple ID and installs app, their habits and history sync automatically.
- No separate registration/login within the app.

#### 6.2.7 Settings / Misc

- Manage habits:
  - Archive habit (hide from Today view but keep history).
- Minimal settings:
  - Optionally toggle Cloud sync on/off (if feasible).
  - “Support the app” section stub (linking to a future support flow; non-functional in V1 if needed).
- About:
  - Short explanation of the philosophy (daily, never zero).
  - Mention that data lives in user’s iCloud (high-level).

---

## 7. V1 – Non-Functional Requirements

- **Performance**
  - Logging interactions must feel instant (<100ms perceived response).
  - History views should scroll smoothly, even with ~1–2 years of data.
- **Reliability**
  - Logging must not fail silently.
  - If sync problems occur (CloudKit), local state should always work; sync later.
- **UX quality**
  - Haptic feedback for state changes.
  - Smooth, non-janky animations for:
    - State transitions.
    - Screen transitions (e.g., onboarding → today).
- **Privacy**
  - No third-party analytics / tracking in V1.
  - No external backend; only CloudKit for sync.

---

## 8. V1 Explicitly Out of Scope

- Social:
  - Friends, leaderboards, group challenges.
  - Shared habits or accountability circles.
- AI:
  - AI-written notifications or habit suggestions.
  - AI-based weekly summaries.
- Scheduling:
  - 3×/week, “Mon/Wed/Fri only”, or monthly counts.
- Account system:
  - Email/password auth, OAuth, or cross-platform accounts.
- Advanced stats:
  - Complex dashboards, comparisons, or “coach” logic.
- Session replay / advanced analytics.

---

## 9. V2 – Wishlist (Next Layer After V1)

These are **post-V1 feature candidates** once the core app feels solid and you’ve used it yourself for a while.

### 9.1 Widgets & Lock Screen Enhancements

- **Interactive logging from widgets**
  - Tap YES/KINDA/NO directly on a widget without opening the app.
- **Lock Screen widgets** (WidgetKit accessory families):
  - `accessoryInline`: text summary (e.g., “3/5 habits today”).
  - `accessoryCircular`: today’s completion ring.
  - `accessoryRectangular`: mini 7-day strip or streak card.

### 9.2 Weekly / Periodic Reviews

- Simple weekly summary inside the app:
  - “This week you showed up X/Y days across your habits.”
  - Per-habit streak changes and consistency.
- Visual “week cards” in the overview:
  - Week-by-week tiles summarizing performance.

### 9.3 Expanded History & Insights

- More robust history views:
  - Ability to scroll back months/years with smooth grouping.
  - Filters by habit, by time range.
- Simple insights:
  - “Your most consistent habit this month”.
  - “Which day of the week you tend to miss most”.

### 9.4 Notifications

- **Generic reminders**:
  - End-of-day reminders to log habits.
  - Optional morning reminder to check Today view.
- Minimal configuration UI:
  - Toggle reminders on/off.
  - Choose EOD time.

### 9.5 Better Habit Creation Experience

- Preset templates:
  - Reading, Movement, Sleep, Deep Work, etc.
  - Pre-filled goals + minimums.
- More polished animations during habit creation.

---

## 10. Future Considerations (Longer-Term / Experimental)

These are **not** for V1 or V2 by default – they’re future experiments if the app gets traction and you want to go deeper.

### 10.1 Social & Accountability

- Add friends.
- Shared challenges (e.g., “Read daily for 30 days”).
- Social feeds (“Omar just finished day 3 of 5 workouts this week”).

### 10.2 AI Features

- **AI-generated motivational notifications**:
  - Habit-specific, contextual nudges.
- AI-based onboarding:
  - Suggesting habit names, goals, and minimums from natural language.
- AI “coach”:
  - Weekly or monthly “reflection prompts” and summaries based on your history.

### 10.3 Advanced Analytics & Tooling

- Privacy-respecting analytics:
  - Aggregate usage metrics (feature-level).
- Session replay tools (e.g., for debugging real user flows, if you decide to move beyond “community service” level and want to optimize UX).
- “Coach” metrics:
  - Adaptive difficulty (adjusting goals/min automatically based on patterns).

### 10.4 Cross-Platform & Backend

- Web client or Android client.
- Dedicated backend (e.g., Supabase) to:
  - Provide cross-platform sync independent of iCloud.
  - Enable social features, shared leaderboards, etc.
- Data migration path from CloudKit-only to a full backend.

### 10.5 Emotional / Avatar Layer

- Inspired by Brainrot-style visual feedback:
  - A simple avatar or visual element that “thrives” with more YES/KINDA days and “wilts” with prolonged NO streaks.
- Seasonal “wrapped” moments:
  - Yearly or quarterly “Your habits wrapped” experiences.

---

## 11. Open Questions / To Decide

1. **Exact logging interaction pattern**  
   - Tap cycle order for the 3 states: NO → KINDA → YES or NO → YES → KINDA.
   - Whether we visually distinguish KINDA strongly from YES (color, opacity, shape).

2. **History layout**  
   - Final decision on:
     - Bottom ribbon + per-habit grid view vs
     - Separate “History” tab.
   - Exact grid style (GitHub clone vs more customized calendar feel).

3. **CloudKit details**
   - How to handle conflict resolution edge cases (multiple devices offline/online).
   - Whether to allow opt-out of sync.

4. **Support / monetization UI**
   - When and how to introduce the optional “support us” screen.
   - Whether it’s a settings-only element or shows occasionally.

5. **Copy & branding**
   - Final tone of voice:
     - Neutral vs slightly science-y / behavior-change flavored.
   - Name + icon (TBD).

---

This PRD gives you:

- A **clear V1 box** to build towards.
- A **V2 wishlist** to pull from once you have something working and in your hands.
- A **future considerations** bucket so you stop mentally carrying nice-to-haves in your critical path.

Next step on your side:  
- Sanity-check V1 scope and, if you want, we can turn this into a **build order** (milestone 0 → 1 → 2) so that you and Claude Code can start shipping incrementally instead of trying to do everything at once.






#another habits chatgpt brain dump


Here’s everything you have told me about the habits app, pulled together and structured so you can see it cleanly.

:one: Motivation & positioning
You’ve tried lots of habit apps and feel:
Many of the good ones are expensive.
Free ones are missing key features or have weak UX.
You would personally use this app for:
Gym,
Sleep,
Deen/spiritual habits,
“Grind time” / deep work, etc.
You think the habits app is simpler to ship than the halal map:
No external data collection/maintenance.
No need to keep restaurant info fresh.
You care a lot about:
Native feel, polish, and animations.
Not shipping something that feels like a bad web wrapper.

:two: Platform & tech
You want it to be a native iOS app, not:
A mobile-optimized React web app.
A React Native / cross-platform app.
You see React mobile/web UX as not great and don’t want to build that.
You want to build it in Swift (SwiftUI implied).
You plan to use Claude Code heavily as your coding partner:
To help scaffold Swift/SwiftUI code.
While you stay in control of structure and decisions.

:three: Core product ideas you’ve given
You’ve actually given two related takes on the habits idea over time:
A. Social habit builder (earlier idea)
From your earlier notes:
Social habit building app:
“Bring social into habit building.”
Friends can compete on habits (e.g., “4 workouts per week”).
Accountability via notifications (“Omar just finished workout #3 of the week, you have 2 days left to catch up”).
AI for notifications:
You explicitly said:
Use AI to generate custom notifications because you can’t manually write them all, especially for arbitrary habits.
AI would come up with habit-specific motivational nudges.
We’ve since de-scoped social for v1, but this is part of the vision you originally had.
B. Better iOS habits app (current flagship direction)
You later refined it into a more personal, UX-focused app:
“Better iOS habits app” with:
Good visuals.
GitHub-style tracking:
Each dot representing a day.
You wrote:
“Each dot has bright YES and a dull KINDA.”
Good widgets.
Questioned whether it should be streak-based or tally-based.
Great animations that feel good.
Native Swift-based – not cross-platform.
Inspired by an iOS app you linked on X that has a very slick, tactile feel.
You also explicitly said:
You agree that animations/UX polish are a must for this habits app.

:four: Monetization & pricing
You want the app to be free to use.
But you’re open to adding a paywall that nudges people to support:
Framed as helping cover maintenance costs.
Crucially: you want a clear “skip” option so people can:
Ignore the paywall and keep using it for free.
So your mental model is:
Core = free forever.
Optional support = ethical nudge, not coercion.
(We talked about a “support us” / tip-jar style screen with “continue for free,” and you liked that general idea.)


:six: UX & “feel” priorities you’ve mentioned
For this app, you’ve been clear about priorities:
Native iOS quality bar:
Swift, not web.
Smooth, delightful animations.
Great-feeling interactions on check-in.
Visual tracking:
GitHub-style grid.
Clear visual difference between strong vs partial completion (YES vs KINDA).
Widgets:
You want good widgets as part of the eventual experience.

:seven: AI angle (from your own words)
Relevant pieces you already said:
In the social habit builder concept:
You wanted AI-generated notifications:
Because you can’t manually author motivational copy for every habit type.
AI would create context-specific prompts/nudges.
For the current habits app:
You haven’t fully nailed the exact AI feature yet,
But you’re already thinking of AI as:
A way to personalize notifications,
Or to augment the experience, not just bolt on “ChatGPT inside the app.”

That’s everything you have told me about the habits app so far:
Native iOS, Swift, Claude-assisted.
Daily personal use.
Better visuals + GitHub-like YES/KINDA grid.
Strong UX/animations.
Free core with an optional “support us” paywall that can be skipped.
Early vision of social + AI-generated notifications as a future layer.