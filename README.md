# 🚀 AI Insights - Flutter Assignment

A modern Flutter application that provides AI-powered productivity insights with a beautiful, responsive UI. Built with clean architecture principles and state management using Provider.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Material Design](https://img.shields.io/badge/Material%20Design-757575?style=for-the-badge&logo=material-design&logoColor=white)

## 📱 Features

### 🔐 Authentication
- **Mock Authentication System** with form validation
- **Persistent Login State** using SharedPreferences
- **Multiple User Support** with pre-configured demo accounts
- **Auto-login** functionality for seamless user experience

### 📊 Dashboard
- **AI-Generated Insights** with randomized productivity metrics
- **Interactive Cards** displaying:
  - Productivity Score with percentage and trends
  - Focus Time tracking with hours and changes
  - Distraction Level monitoring
  - Task completion statistics
  - Energy level indicators
- **Trend Indicators** (📈 Up, 📉 Down, ➡️ Stable)
- **Pull-to-Refresh** functionality for data updates
- **Smooth Animations** with staggered card loading

### 💡 Smart Recommendations
- **Personalized Suggestions** based on productivity patterns
- **Dynamic Content** that changes with each refresh
- **Actionable Tips** for productivity improvement

### ⚙️ Settings & Customization
- **Theme Toggle** (Light/Dark mode) with persistence
- **User Profile** display with avatar and information
- **App Information** and version details
- **Secure Logout** functionality

### 🎨 Modern UI/UX
- **Material 3 Design** with custom color scheme
- **Responsive Layout** that works on different screen sizes
- **Smooth Animations** and transitions
- **Custom Color Palette** (Purple-Pink gradient theme)
- **Error Handling** with user-friendly messages

## 🏗️ Architecture

This project follows **Clean Architecture** principles:

```
lib/
├── core/                    # Core utilities and constants
│   ├── constants/          # App colors and strings
│   ├── theme/             # Theme configuration
│   └── utils/             # Validators and helpers
├── data/                   # Data layer
│   ├── models/            # Data models (User, Insight)
│   ├── repositories/      # Repository implementations
│   └── services/          # Mock API services
└── presentation/          # Presentation layer
    ├── providers/         # State management (Provider)
    ├── screens/          # UI screens
    └── widgets/          # Reusable UI components
```

## 🛠️ Technologies Used

- **Framework**: Flutter 3.8.1+
- **Language**: Dart with null safety
- **State Management**: Provider pattern
- **Local Storage**: SharedPreferences
- **Architecture**: Clean Architecture with Repository pattern
- **Testing**: Unit tests for business logic
- **UI**: Material 3 with custom theming

## 📦 Dependencies

```yaml
dependencies:
  flutter: sdk
  provider: ^6.1.1           # State management
  shared_preferences: ^2.2.2  # Local storage
  http: ^1.1.0               # HTTP client
  animations: ^2.0.11        # Enhanced animations
  flutter_svg: ^2.0.9        # SVG support

dev_dependencies:
  flutter_test: sdk
  flutter_lints: ^5.0.0      # Linting rules
```

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: 3.8.1 or higher
- **Dart SDK**: 3.8.1 or higher
- **Android Studio** or **VS Code** with Flutter plugins
- **Android SDK** (for Android development)
- **Xcode** (for iOS development - macOS only)

### Installation Steps

1. **Clone the Repository**
   ```bash
   git clone https://github.com/kumarsatyam444/flutter_assignment.git
   cd flutter_assignment
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the App**
   ```bash
   # For Android/iOS device
   flutter run
   
   # For specific device
   flutter run -d <device-id>
   
   # For web
   flutter run -d chrome
   
   # For desktop
   flutter run -d windows  # or macos/linux
   ```

### Demo Credentials

Use these credentials to login and explore the app:

| Email | Password | User |
|-------|----------|------|
| `test@example.com` | `password123` | John Doe |
| `jane@example.com` | `password123` | Jane Smith |
| `mike@example.com` | `password123` | Mike Johnson |

## 🧪 Testing

### Run Unit Tests
```bash
flutter test
```

### Run Tests with Coverage
```bash
flutter test --coverage
```

### Test Files
- `test/auth_service_test.dart` - Authentication service tests
- `test/dashboard_service_test.dart` - Dashboard service tests  
- `test/validators_test.dart` - Form validation tests

## 🏗️ Build for Production

### Android APK
```bash
flutter build apk --release
```

### iOS App
```bash
flutter build ios --release
```

### Web App
```bash
flutter build web --release
```

## 📱 App Screenshots

*Login Screen*
- Clean, modern login interface
- Form validation with error messages
- Demo credentials display
- Smooth animations

*Dashboard*
- Card-based insight layout
- Trend indicators with colors
- Pull-to-refresh functionality
- Personalized recommendations

*Settings*
- Theme toggle (Light/Dark)
- User profile display
- App information
- Secure logout

## 🔧 Configuration

### Changing App Colors
Edit `lib/core/constants/app_colors.dart`:
```dart
static const Color primary = Color(0xFF6C63FF);  // Purple
static const Color accent = Color(0xFFFF6B9D);   // Pink
```

### Adding New Insights
Modify `lib/data/services/dashboard_service.dart` to add custom insights.

### Customizing Themes
Update `lib/core/theme/app_theme.dart` for theme modifications.

## 📂 Project Structure Details

```
flutter_assignment/
├── android/                 # Android-specific files
├── ios/                    # iOS-specific files  
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart     # Color definitions
│   │   │   └── app_strings.dart    # String constants
│   │   ├── theme/
│   │   │   └── app_theme.dart      # Theme configuration
│   │   └── utils/
│   │       └── validators.dart     # Form validators
│   ├── data/
│   │   ├── models/
│   │   │   ├── user_model.dart     # User data model
│   │   │   └── insight_model.dart  # Insight data model
│   │   ├── repositories/
│   │   │   ├── auth_repository.dart      # Auth repository
│   │   │   └── dashboard_repository.dart # Dashboard repository
│   │   └── services/
│   │       ├── auth_service.dart         # Mock auth service
│   │       ├── dashboard_service.dart    # Mock dashboard service
│   │       └── storage_service.dart      # Local storage service
│   ├── presentation/
│   │   ├── providers/
│   │   │   ├── auth_provider.dart        # Auth state management
│   │   │   ├── dashboard_provider.dart   # Dashboard state
│   │   │   └── theme_provider.dart       # Theme state
│   │   ├── screens/
│   │   │   ├── auth/
│   │   │   │   └── login_screen.dart     # Login interface
│   │   │   ├── dashboard/
│   │   │   │   └── dashboard_screen.dart # Main dashboard
│   │   │   └── settings/
│   │   │       └── settings_screen.dart  # Settings page
│   │   └── widgets/
│   │       ├── common/
│   │       │   ├── app_button.dart       # Custom button
│   │       │   ├── app_text_field.dart   # Custom input field
│   │       │   └── loading_widget.dart   # Loading components
│   │       └── dashboard/
│   │           ├── insight_card.dart     # Insight display card
│   │           └── recommendation_tile.dart # Recommendation item
│   └── main.dart                        # App entry point
├── test/                               # Unit tests
└── pubspec.yaml                        # Dependencies
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Developer

**Kumar Satyam**
- GitHub: [@kumarsatyam444](https://github.com/kumarsatyam444)
- Email: kumarsatyam444@gmail.com

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design for UI guidelines
- Provider package for state management
- The Flutter community for inspiration

---

### 🚀 Ready to explore AI-powered productivity insights? Clone and run the app today!

```bash
git clone https://github.com/kumarsatyam444/flutter_assignment.git
cd flutter_assignment
flutter pub get
flutter run
```

*Happy Coding! 🎉*
