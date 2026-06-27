# Project Title : Electro Task Manager

# Project BackEnd : Node.js

## Project Description :

Task management mobile application built for an interview submission.  
The app supports authentication, projects, tasks, profile, token persistence, dark mode, and a polished animated UI.

**Types of users**

1. USER

**FLUTTER_VERSION** : 3.35.1

## Links for development :

1. [Backend README](../backend/README.md)
2. [Design System](../outputs/stitch/design_system/DESIGN.md)
3. [Generated Stitch Screens](../outputs/stitch/screens/)
4. [Generated Stitch Code](../outputs/stitch/code/)
5. [Test_file]()

## Dashboard :

1. [Link]()
2. dashboard account :
   - email : demo@electro.dev
   - password : Password123

## Accounts for App :

[USER]===> demo@electro.dev
- password : Password123



## App Bundle :

- Android : com.example.electro_task_manager
- iOS : com.example.electroTaskManager


## Team members :

1. **Flutter**
   - Hatem Elbadwy

2. **Backend**
   - Hatem Elbadwy

3. **Testing**
   - Manual testing

## Image :

![Logo](assets/images/electro_task_manager_logo.png)

## App Features :

1. Splash / auth session check
2. Login and registration
3. Secure token storage
4. Projects list
5. Project details and tasks
6. Add task
7. Mark task as done
8. Delete task
9. Profile and settings
10. Dark mode toggle
11. Loading, empty, and error states
12. Animated lists and quick actions popup

## Project Structure :

```text
lib/
  main.dart
  core/
  modules/
    common/
      features/
        auth/
        profile/
        projects/
        splash/
        tasks/
```

## Main Packages :

```yaml
flutter_bloc
go_router
get_it
dio
flutter_secure_storage
easy_localization
flutter_staggered_animations
popup_quick_actions
```

## Backend Run :

```bash
cd backend
npm start
```

The API runs at:

```text
http://localhost:3000
```

For Android emulator use:

```text
http://10.0.2.2:3000
```

## Flutter Run :

```bash
flutter pub get
flutter run
```

## Release APK :

```bash
flutter build apk --release --dart-define=API_BASE_URL=https://your-backend-url
```

For local debug:

```bash
flutter run --dart-define=API_BASE_URL=http://localhost:3000
```

For Android emulator:

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000
```

## API Endpoints :

```text
POST /api/auth/register
POST /api/auth/login
GET  /api/me

GET    /api/projects
POST   /api/projects
GET    /api/projects/:id
PATCH  /api/projects/:id
DELETE /api/projects/:id

GET    /api/projects/:projectId/tasks
POST   /api/projects/:projectId/tasks
PATCH  /api/tasks/:id
PATCH  /api/tasks/:id/done
DELETE /api/tasks/:id
```

## Notes :

- Backend data is currently in-memory for interview/demo purposes.
- If the backend server stops, data resets to the initial seed.
- Authentication uses Bearer token.
- Project status is synced based on task completion state.

## Localization Generator:

### Run this Command to generate localization files

```bash
dart run generate/strings/main.dart
```
