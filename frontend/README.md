# Design Analysis Frontend

Flutter web application for the Design Analysis backend API. Built with **go_router** for navigation and **flutter_bloc** for state management.

## Features

- 🚀 Modern Flutter web app with Material Design 3
- 🧭 Go Router for declarative routing
- 🎯 BLoC pattern for state management
- 🌐 HTTP client integration with backend API
- 📱 Responsive UI design

## Project Structure

```
lib/
├── core/
│   ├── config/          # App configuration (API URLs, etc.)
│   ├── di/              # Dependency injection
│   ├── models/          # Data models with JSON serialization
│   ├── router/          # Go Router configuration
│   └── services/        # API service layer
├── features/
│   ├── analysis/        # Analysis feature
│   │   └── presentation/
│   │       ├── bloc/    # BLoC (events, states, bloc)
│   │       └── pages/   # UI pages
│   └── home/            # Home feature
│       └── presentation/
│           └── pages/
└── main.dart            # App entry point
```

## Setup

1. **Install Flutter dependencies:**
   ```bash
   flutter pub get
   ```

2. **Generate JSON serialization code:**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. **Configure API endpoint:**
   - Update `lib/core/config/app_config.dart` with your backend URL
   - Default is `http://localhost:8000` for local development

4. **Run the app:**
   ```bash
   flutter run -d chrome
   ```

## Backend Integration

This frontend connects to the FastAPI backend located in the parent directory (`/Users/govind/Dev/personel/design_analysis/`).

### API Endpoints Used:
- `GET /health` - Health check
- `POST /analyze` - Submit new analysis
- `GET /analyze/{request_id}` - Get analysis by ID
- `GET /analyses` - List all analyses
- `GET /implementations` - Get available implementations
- `GET /stats` - Get statistics
- `DELETE /analyze/{request_id}` - Delete analysis

## Dependencies

- **go_router**: ^14.2.0 - Declarative routing
- **flutter_bloc**: ^8.1.6 - State management
- **equatable**: ^2.0.5 - Value equality
- **http**: ^1.2.0 - HTTP client
- **json_annotation**: ^4.9.0 - JSON serialization

## Development

### Running in Development Mode
```bash
flutter run -d chrome --web-port=8080
```

### Building for Production
```bash
flutter build web
```

The built files will be in `build/web/` directory.

## Routes

- `/` - Home page
- `/analysis` - Create new analysis
- `/analysis/:id` - View analysis details

## Notes

- Make sure the backend API is running before using the frontend
- CORS is configured in the backend to allow requests from the frontend
- The app uses BLoC pattern for predictable state management
- All API calls are handled through the `ApiService` class
