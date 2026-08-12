# 🏋️ CodeAlpha Fitness Tracker

[![Flutter](https://img.shields.io/badge/Flutter-v3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-v3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![SQLite](https://img.shields.io/badge/SQLite-v2.x-003B57?style=for-the-badge&logo=sqlite&logoColor=white)](https://www.sqlite.org)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](#-license)

A feature-rich, modern cross-platform **Fitness & Hydration Tracker App** built using **Flutter, Dart, and SQLite**. Developed as part of the **CodeAlpha App Development Internship**, this application enables users to track daily workouts, log water intake, monitor daily fitness goals, and analyze performance trends with interactive data visualizations.

---

## 📱 Features

### 🏃 Activity & Workout Tracking
* **Comprehensive Logging:** Track exercise type, duration (minutes), calories burned (kcal), steps completed, and workout date.
* **Exercise Types:** Choose from preset activities (Running, Cycling, Swimming, Walking, Gym, Yoga, etc.) or custom workouts.
* **Full CRUD Operations:** Create, view, update, and delete workout entries with intuitive swipe-to-delete gestures.
* **Search & Filtering:** Search and filter historical fitness logs seamlessly.

### 💧 Water Intake Tracker
* **Hydration Management:** Log fluid consumption and track real-time progress toward customized daily targets (in mL).
* **Quick Log Actions:** One-tap preset increments (+250 mL, +500 mL) alongside custom intake entries.
* **Log History:** Timestamps for each hydration log with easy deletion options.

### 📊 Dashboard & Progress Tracking
* **Metric Overview:** Real-time summary cards for total calories burned, steps taken, active workout minutes, and water intake.
* **Progress Indicators:** Animated circular and linear progress indicators reflecting percentage towards daily goals.
* **Today's Activity Feed:** Instant view of workouts logged today directly from the main screen.

### 📈 Analytics & Reports (`fl_chart`)
* **Weekly Calories Chart:** Interactive bar graphs tracking energy expenditure across days of the week.
* **Step Trends Chart:** Line graphs showing step count variations over time.
* **Workout Duration Analysis:** Visual breakdown of active workout minutes.
* **Insights & Streaks:** Calculates current workout streak, best performance day, and goal completion rates.

### ⚙️ Customizable Goals & Profile
* **Target Customization:** Personalize target goals for Calories (kcal), Steps, Workout Duration (mins), and Water Intake (mL).
* **Local Persistence:** Automated synchronization and storage of user goals via SQLite.
* **Material 3 Design:** Sleek UI with custom color palettes, smooth transitions, and responsive layout across mobile screens.

---

## 🛠️ Tech Stack & Dependencies

| Category | Technology / Package | Purpose |
| :--- | :--- | :--- |
| **Framework** | [Flutter](https://flutter.dev) | Cross-platform UI framework for mobile applications |
| **Language** | [Dart](https://dart.dev) | Object-oriented client-optimized language |
| **Database** | [SQLite](https://www.sqlite.org) / [`sqflite`](https://pub.dev/packages/sqflite) | Local persistent relational database |
| **Data Viz** | [`fl_chart`](https://pub.dev/packages/fl_chart) | Interactive charts for weekly statistics |
| **Formatting** | [`intl`](https://pub.dev/packages/intl) | Date and time parsing & formatting |
| **UI Widgets** | [`percent_indicator`](https://pub.dev/packages/percent_indicator) | Circular & linear goal progress indicators |
| **Design** | Material 3 | Modern UI design system and components |

---

## 🏗️ Project Structure

The project follows a clean, modular structure separating UI components, database operations, business services, and models:

```text
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart          # Palette colors & theme tokens
│   │   ├── app_constants.dart       # General app string & numeric constants
│   │   └── app_theme.dart           # Material 3 light/dark theme config
│   └── utils/
│       ├── date_utils.dart          # Helper methods for date/time formatting
│       └── validators.dart          # Input field validation rules
│
├── database/
│   └── database_helper.dart         # SQLite connection manager & CRUD operations
│
├── models/
│   ├── activity.dart                # Workout/Activity entity model
│   ├── user_goal.dart               # User goal settings model
│   └── water_log.dart               # Water log entry model
│
├── services/
│   ├── goal_service.dart            # Business logic for managing daily goals
│   ├── stats_service.dart           # Data aggregation & analytics for charts
│   └── water_service.dart           # Business logic for water tracking
│
├── screens/
│   ├── activity_history_screen.dart # Filterable history of all activities
│   ├── add_activity_screen.dart     # Form to log or edit workout sessions
│   ├── home_screen.dart             # Main dashboard screen
│   ├── main_navigation.dart        # Bottom navigation container
│   ├── profile_screen.dart          # Goal configuration & user profile
│   ├── statistics_screen.dart       # Weekly charts & progress insights
│   └── water_tracker_screen.dart    # Hydration tracking & history
│
├── widgets/
│   ├── activity_card.dart           # Card for displaying activity items
│   ├── circular_progress.dart       # Circular goal progress widget
│   ├── custom_button.dart           # Styled elevated button component
│   ├── custom_textfield.dart        # Reusable form textfield widget
│   ├── dashboard_header.dart        # Dashboard welcome header
│   ├── goal_progress.dart           # Linear progress bar for target goals
│   ├── progress_card.dart           # Summary metric card widget
│   ├── statistics_summary.dart      # Summary stats widget for analytics
│   ├── weekly_calories_chart.dart   # FL Chart bar graph for calorie trends
│   ├── weekly_steps_chart.dart      # FL Chart line graph for step trends
│   └── weekly_workout_chart.dart    # FL Chart bar graph for workout minutes
│
└── main.dart                        # Application entry point
```

---

## 🗄️ Database Schema

Data is stored locally in an SQLite database (`fitness.db`) using `DatabaseHelper`.

### 1. `activities` Table
| Column | Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | `INTEGER` | `PRIMARY KEY AUTOINCREMENT` | Unique activity identifier |
| `exercise` | `TEXT` | `NOT NULL` | Name or type of exercise |
| `duration` | `INTEGER` | `NOT NULL` | Workout duration in minutes |
| `calories` | `INTEGER` | `NOT NULL` | Energy burned in kcal |
| `steps` | `INTEGER` | `NOT NULL` | Step count completed |
| `date` | `TEXT` | `NOT NULL` | ISO formatted date string (`YYYY-MM-DD`) |

### 2. `water_logs` Table
| Column | Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | `INTEGER` | `PRIMARY KEY AUTOINCREMENT` | Unique hydration log ID |
| `amount` | `INTEGER` | `NOT NULL` | Water intake amount in mL |
| `date` | `TEXT` | `NOT NULL` | Log date (`YYYY-MM-DD`) |
| `timestamp` | `TEXT` | `NOT NULL` | Log time string (`HH:mm`) |

### 3. `user_goals` Table
| Column | Type | Constraints | Default Value | Description |
| :--- | :--- | :--- | :--- | :--- |
| `id` | `INTEGER` | `PRIMARY KEY` | `1` | Single user settings row |
| `calorieGoal` | `INTEGER` | `NOT NULL` | `2000` | Target daily calories (kcal) |
| `stepGoal` | `INTEGER` | `NOT NULL` | `10000` | Target daily steps |
| `workoutGoal` | `INTEGER` | `NOT NULL` | `60` | Target daily workout minutes |
| `waterGoal` | `INTEGER` | `NOT NULL` | `2500` | Target daily water intake (mL) |

---

## 🔄 Application Architecture Flow

```text
                        ┌───────────────────┐
                        │   Launch App      │
                        └─────────┬─────────┘
                                  │
                                  ▼
                        ┌───────────────────┐
                        │  Main Navigation  │
                        └─────────┬─────────┘
                                  │
         ┌───────────────┬────────┴───────┬───────────────┐
         ▼               ▼                ▼               ▼
   ┌───────────┐   ┌───────────┐    ┌───────────┐   ┌───────────┐
   │ Dashboard │   │ Activity  │    │   Water   │   │ Analytics │
   │  (Home)   │   │  History  │    │  Tracker  │   │  & Stats  │
   └─────┬─────┘   └─────┬─────┘    └─────┬─────┘   └─────┬─────┘
         │               │                │               │
         └───────────────┼────────────────┴───────────────┘
                         │
                         ▼
             ┌───────────────────────┐
             │ SQLite Local Storage  │
             │     (fitness.db)      │
             └───────────────────────┘
```

---

## 🚀 Getting Started

Follow these steps to run the application on your local development machine.

### Prerequisites

* [Flutter SDK](https://docs.flutter.dev/get-started/install) (`v3.19.0` or higher)
* [Dart SDK](https://dart.dev/get-started)
* Android Studio / VS Code with Flutter plugins
* Android Emulator or connected physical device

### Installation & Execution

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Manoj-1Kumar/CodeAlpha_FitnessTracker.git
   ```

2. **Navigate into the directory:**
   ```bash
   cd codealpha_fitness_tracker
   ```

3. **Install dependencies:**
   ```bash
   flutter pub get
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```

---

## 📦 Release Build

To build an Android APK for distribution:

```bash
flutter build apk --release
```

The output file will be generated at:
```text
build/app/outputs/flutter-apk/app-release.apk
```

---

## 👨‍💻 Internship & Author Information

* **Internship:** CodeAlpha App Development Internship
* **Task:** Fitness Tracker Application
* **Developer:** Manojkumar P
* **Degree:** B.Tech Information Technology

---

## 📄 License

This repository is developed for educational and internship demonstration purposes.
