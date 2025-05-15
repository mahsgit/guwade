# Buddy - Interactive Learning App for Kids

Buddy is a Flutter application designed for children aged 4-8 years old, providing an interactive and engaging learning experience through stories, STEAM content, and quizzes.

## Features

- **Authentication**: Kid-friendly login interface
- **Storytelling**: Interactive stories with emotion detection
- **STEAM Content**: Educational videos and activities
- **Quizzes**: Interactive quizzes based on stories and STEAM content
- **Achievements**: Track progress and earn badges
- **Profile**: Personal learning progress tracking

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Android SDK / Xcode (for iOS development)

### Installation

1. Clone the repository:

```bash
git clone https://github.com/yourusername/buddy.git
```

2. Navigate to the project directory:

```bash
cd buddy
```

3. Install dependencies:

```bash
flutter pub get
```

4. Run the app:

```bash
flutter run
```

## Project Structure

The project follows clean architecture principles and is organized as follows:

```
lib/
  ├── core/                 # Core functionality and utilities
  │   ├── error/           # Error handling
  │   ├── network/         # Network utilities
  │   └── injection/       # Dependency injection
  │
  └── features/            # Application features
      ├── auth/            # Authentication feature
      ├── storytelling/    # Storytelling feature
      ├── steam/           # STEAM content feature
      └── quiz/            # Quiz feature
```

## Architecture

The application follows Clean Architecture principles with the following layers:

- **Domain**: Business logic and entities
- **Data**: Data handling and repositories
- **Presentation**: UI and state management

## Dependencies

- **State Management**: flutter_bloc
- **Dependency Injection**: get_it
- **Network**: http
- **Camera**: camera (for emotion detection)

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
