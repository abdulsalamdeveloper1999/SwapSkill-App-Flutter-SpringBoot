# SkillSwap

SkillSwap is a mobile application that connects users based on complementary skills, enabling them to teach and learn from each other. Built with Flutter and Spring Boot, this app facilitates skill exchange through a matching algorithm and real-time chat functionality.

## Features

### Authentication
- Secure JWT-based authentication
- User registration and login
- Complete user profile setup

### Skill Management
- Add skills you can teach others
- Add skills you want to learn
- Set proficiency levels and interests

### Skill Matching
- View other users' skills with matching scores
- Filter users by teach/learn compatibility
- Send skill exchange requests

### Real-time Interaction
- Accept or decline skill exchange requests
- Real-time chat with matched users

## Tech Stack

### Mobile Application (Frontend)
- Flutter for cross-platform mobile development
- Provider for state management
- Dio for REST API communication


### Server (Backend)
- Spring Boot for robust API development
- Spring Security with JWT authentication
- PostgreSQL database (or your preferred database)

## Getting Started

### Prerequisites
- Flutter SDK 
- Dart 
- JDK 17 or higher
- Maven 
- MySql 

### Installation

#### Backend Setup
1. Clone the repository
   ```
   git clone [https://github.com/yourusername/skillswap.git](https://github.com/abdulsalamdeveloper1999/SwapSkill-App-Flutter-SpringBoot.git)
   cd skillswap/backend
   ```

2. Configure database in `application.properties`
   ```
   spring.datasource.url=jdbc:postgresql://localhost:5432/skillswap
   spring.datasource.username=postgres
   spring.datasource.password=yourpassword
   ```

3. Generate JWT secret key and configure in `application.properties`
   ```
   jwt.secret=your_jwt_secret_key
   jwt.expiration=86400000
   ```

4. Build and run the Spring Boot application
   ```
   ./mvnw spring-boot:run
   ```
   or with Gradle:
   ```
   ./gradlew bootRun
   ```

#### Frontend Setup
1. Navigate to the frontend directory
   ```
   cd ../frontend
   ```

2. Install dependencies
   ```
   flutter pub get
   ```

3. Configure API endpoint in `lib/config/api_config.dart`
   ```dart
   class ApiConfig {
     static const String baseUrl = 'http://your-backend-url:8080/api';
     static const String wsUrl = 'ws://your-backend-url:8080/ws';
   }
   ```

4. Run the application
   ```
   flutter run
   ```

## Project Structure

### Backend
```
backend/
├── src/
│   ├── main/
│   │   ├── java/com/skillswap/
│   │   │   ├── config/          # Configuration classes
│   │   │   ├── controller/      # REST API controllers
│   │   │   ├── dto/             # Data Transfer Objects
│   │   │   ├── exception/       # Custom exceptions
│   │   │   ├── model/           # Entity classes
│   │   │   ├── repository/      # Database repositories
│   │   │   ├── security/        # JWT and security config
│   │   │   ├── service/         # Business logic services
│   │   │  
│   │   └── resources/
│   │       └── application.properties
│   └── test/                    # Unit and integration tests
```

### Frontend
```
frontend/
├── lib/
│   ├── config/                  # Configuration files
│   ├── models/                  # Data models
│   ├── providers/               # State management
│   ├── screens/                 # UI screens
│   ├── services/                # API services
│   ├── utils/                   # Utility functions
│   └── widgets/                 # Reusable widgets
├── pubspec.yaml                 # Dependencies
└── test/                        # Unit and widget tests
```

## Contribute
Contributions are welcome! Please feel free to submit a Pull Request.

## License
This project is licensed under the MIT License - see the LICENSE file for details.
