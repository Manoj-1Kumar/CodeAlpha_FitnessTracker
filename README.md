# 💪 Fitness Tracker App

A modern **Fitness Tracker mobile application** built with **Flutter and Dart** as part of my **CodeAlpha App Development Internship**.

The application allows users to manually record their fitness activities and monitor daily and weekly progress through an interactive dashboard.

---

## 📱 Features

### 🏃 Activity Tracking

* Add fitness activities
* Record exercise name
* Record workout duration
* Record calories burned
* Record steps
* Edit activities
* Delete activities

### 📊 Dashboard

* 🔥 Daily calories
* 👣 Daily steps
* ⏱️ Workout duration
* 🎯 Daily fitness goals
* 📈 Circular progress indicators
* 📋 Today's activities

### 📈 Statistics

* Weekly calorie statistics
* Weekly step statistics
* Weekly workout duration
* Goal completion
* Workout streak
* Best workout day

### 🎨 UI & UX

* Modern Material 3 interface
* Gradient dashboard header
* Animated progress indicators
* Responsive layout
* Pull-to-refresh
* Swipe-to-delete
* Exercise-specific icons

---

## 🛠️ Technologies Used

| Technology | Purpose                        |
| ---------- | ------------------------------ |
| Flutter    | Mobile application development |
| Dart       | Programming language           |
| SQLite     | Local fitness data storage     |
| sqflite    | SQLite integration             |
| fl_chart   | Data visualization             |
| intl       | Date formatting                |
| Material 3 | UI design                      |

---

## 🏗️ Project Structure

```text
lib/
│
├── core/
│   └── constants/
│       ├── app_colors.dart
│       ├── app_theme.dart
│       └── app_constants.dart
│
├── database/
│   └── database_helper.dart
│
├── models/
│   ├── activity.dart
│   ├── goal.dart
│   └── water_intake.dart
│
├── services/
│   ├── stats_service.dart
│   ├── goal_service.dart
│   └── water_service.dart
│
├── screens/
│   ├── home/
│   ├── activity/
│   ├── statistics/
│   ├── profile/
│   └── navigation/
│
├── widgets/
│   ├── dashboard_header.dart
│   ├── circular_progress_card.dart
│   ├── activity_card.dart
│   ├── goal_progress.dart
│   └── custom_button.dart
│
└── main.dart
```

---

## 🗄️ Database

Fitness activities are stored locally using SQLite.

### Activities Table

| Column   | Type    | Description      |
| -------- | ------- | ---------------- |
| id       | INTEGER | Primary key      |
| exercise | TEXT    | Exercise name    |
| duration | INTEGER | Workout duration |
| calories | INTEGER | Calories burned  |
| steps    | INTEGER | Steps completed  |
| date     | TEXT    | Activity date    |

---

## 🔄 Application Flow

```text
              Launch App
                  │
                  ▼
             Home Dashboard
                  │
        ┌─────────┼─────────┐
        ▼         ▼         ▼
      Home     Statistics  Profile
        │
        ▼
   Add Activity
        │
        ▼
   Validate Input
        │
        ▼
   SQLite Database
        │
        ▼
 Update Dashboard
        │
        ▼
 Calculate Progress
```

---

## 🎯 Daily Goals

The dashboard tracks progress toward daily fitness goals.

Example:

```text
Calories

420 / 600 kcal

████████████░░░░░

70%
```

```text
Steps

7200 / 10000

██████████████░░░

72%
```

```text
Workout

45 / 60 min

███████████████░░

75%
```

Progress indicators update automatically based on the activities stored in the database.

---

## 📈 Weekly Statistics

The Statistics section analyzes the user's recent activity data and presents weekly trends.

```text
Weekly Calories

Mon  █████
Tue  ███████
Wed  ███
Thu  █████████
Fri  ██████
Sat  ████████
Sun  █████
```

The application calculates:

* Total calories
* Total steps
* Total workout duration
* Best workout day
* Workout streak
* Goal completion

---

## 🗑️ Activity Management

Users can manage their recorded activities through:

### Add

```text
Exercise
Duration
Calories
Steps
       ↓
     Save
```

### Edit

Existing activity information can be modified.

### Delete

Activities can be deleted through the delete option or swipe gesture.

---


## 🚀 Getting Started

### Prerequisites

Install:

* Flutter SDK
* Dart SDK
* Android Studio or VS Code
* Android Emulator or physical Android device

### Clone Repository

```bash
git clone https://github.com/Manoj-1Kumar/CodeAlpha_FitnessTracker.git
```

### Navigate to Project

```bash
cd codealpha_fitness_tracker
```

### Install Dependencies

```bash
flutter pub get
```

### Run Application

```bash
flutter run
```

---

## 📦 Build APK

Generate a release APK:

```bash
flutter build apk --release
```

APK location:

```text
build/app/outputs/flutter-apk/app-release.apk
```

---

## 🔗 Internship

This project was developed as part of my **CodeAlpha App Development Internship**.

The project fulfills the **Fitness Tracker App** task requirement.

---

## 👨‍💻 Developer

**Manojkumar P**

B.Tech Information Technology

---

## ⭐ Support

If you find this project useful, consider giving the repository a ⭐.

---

## 📄 License

This project is created for educational and internship purposes.
