# Project Overview

**Hemaya** is an IoT monitoring and control app that integrates with the **eWeLink** platform to interact with **Sonoff AirGuard TH** — an indoor smart Zigbee temperature and humidity sensor.

### Core Capabilities

- **Sensor Reads**: Fetch temperature and humidity data from the Sonoff AirGuard TH sensor, supporting both **one-time** (on-demand) and **real-time** (continuous/streaming) read modes.
- **Camera Screenshots**: Capture and display screenshots from a connected camera.
- **Threshold Control**: Configure and adjust sensor threshold values (e.g., temperature/humidity limits) to define alert or automation boundaries.

### Integration

- **eWeLink API**: The app communicates with eWeLink cloud services to authenticate, discover devices, read sensor data, and send control commands to the Sonoff AirGuard TH device.

---

# Architecture: Clean Architecture (Feature-First)

## Folder Structure

```
lib/
├── core/                          # Shared utilities, DI, routing, widgets
│   ├── DI/                        # GetIt + Injectable dependency injection
│   ├── remote/local/              # Local storage (SharedPreferences via PrefsManager)
│   ├── resources/                 # Theme, colors, fonts, values, assets, API result, internet checker
│   ├── routes_manager/            # Named routes (Routes class) + RouteGenerator
│   └── widget/                    # Reusable UI widgets (BuildTextField, CustomElevatedButton, validators, etc.)
├── features/
│   └── <feature_name>/
│       ├── api/                   # Retrofit client (@RestApi abstract class)
│       ├── data/
│       │   ├── datasource/        # Abstract interface (DAO) — e.g. AuthDao
│       │   ├── datasource_impl/   # Concrete implementation — e.g. AuthApiDaoImpl
│       │   ├── model/             # JSON models (@JsonSerializable) with toEntity() mapper
│       │   └── repo_impl/         # Repository implementation
│       ├── domain/
│       │   ├── entity/            # Clean domain entities (no JSON annotations)
│       │   ├── repo/              # Abstract repository interface
│       │   └── usecase/           # Use cases (single call() method)
│       └── presentation/
│           ├── screens/           # UI screens
│           └── viewmodels/
│               └── <action_name>/ # Cubit + State per action (e.g. signup/, signin/)
└── main.dart
```

## Layer Rules

1. **Data layer** depends on domain layer (for entities) and API layer (for Retrofit clients)
2. **Domain layer** has NO dependency on data layer — only defines interfaces and entities
3. **Presentation layer** depends on domain layer (entities, use cases) — never on data layer directly
4. **Models** (data layer) contain `toEntity()` mapper methods to convert to domain entities
5. **Entities** (domain layer) are plain Dart classes with no serialization annotations

---

# Naming Conventions

| Element | Pattern | Example |
|---|---|---|
| Feature folder | `snake_case` | `auth/`, `cart/`, `product_details/` |
| Retrofit client | `<Feature>Client` | `AuthClient` |
| Data source interface | `<Feature>Dao` (abstract interface class) | `AuthDao` |
| Data source impl | `<Feature>ApiDaoImpl` | `AuthApiDaoImpl` |
| Response model | `<Feature>Response` | `AuthResponse` |
| Domain entity | `<Feature>Entity` | `AuthEntity` |
| Domain repo interface | `<Feature>Repo` (abstract interface class) | `AuthRepo` |
| Domain repo impl | `<Feature>RepoImpl` | `AuthRepoImpl` |
| Use case | `<Action>UseCase` | `SignupUseCase`, `SigninUseCase` |
| Cubit | `<Action>ViewModelCubit` | `SignupViewModelCubit` |
| State | `<Action>ViewModelState` (sealed class) | `SignupViewModelState` |
| Screen | `<Action>Screen` | `SignInScreen`, `SignUpScreen` |
| File names | `snake_case.dart` | `auth_client.dart`, `signup_use_case.dart` |

---

# Dependency Injection

- **Framework**: `get_it` + `injectable` (with `injectable_generator`)
- **Configuration**: `lib/core/DI/di.dart` calls `getIt.init()` from auto-generated `di.config.dart`
- **Annotations**:
    - `@singleton` — Retrofit clients, use cases, Dio module
    - `@injectable` — Cubits, repository implementations, DAO implementations
    - `@factoryMethod` — on Retrofit client factory constructors
    - `@Injectable(as: AuthDao)` — bind implementation to its abstract interface
    - `@module` — for `ClientModule` providing Dio instance
- **Access pattern**: `getIt.get<SignupViewModelCubit>()` in screens

---

# API / Networking

- **HTTP client**: Dio with `PrettyDioLogger` interceptor
- **Dio validateStatus**: returns `true` for status < 500 (handles 4xx as valid responses for error parsing)
- **API client**: Retrofit (`@RestApi`) abstract classes with `part` directive for generated code
- **Request body**: `@Body() Map<String, dynamic>` — not typed request models
- **Response parsing**: `@JsonSerializable()` models with `fromJson`/`toJson` via `json_serializable`
- **Error detection pattern**: Check `statusMsg` field in response — if non-null, it is an error; use `message` field for error text
- **API result wrapper**: `sealed class ApiResult<T>` with `Success<T>(response)` and `Error<T>(message)` — located in `core/resources/api_result.dart`
- **Internet check**: Always check connectivity via `InternetChecker.checkConnection()` in repo_impl before API calls; return `Error("No Internet Connection")` if offline

---

# State Management (MVVM with Bloc/Cubit)

- **Pattern**: One Cubit per action/feature operation (not one per screen)
- **State**: Sealed class with 4 variants: `Initial`, `Loading`, `Success`, `Error`
- **Cubit file** uses `part` directive for state file: `part '<name>_state.dart';`
- **BlocProvider**: Created at the screen level using `BlocProvider(create: (context) => getIt.get<XxxCubit>())`
- **BlocConsumer**: Used on action buttons — `listener` handles navigation/dialogs, `builder` handles loading state

---

# UI / Design System

- **Responsive sizing**: `flutter_screenutil` — use `.h`, `.w`, `.sp`, `.r` extensions
- **Colors**: Use `ColorManager` static fields (never hardcode hex values)
- **Typography**: Use style functions `getBoldStyle()`, `getMediumStyle()`, `getSemiBoldStyle()`, `getLightStyle()`, `getRegularStyle()` from `styles_manager.dart`
- **Spacing**: Use `AppSize`, `AppPadding`, `AppMargin` constants from `values_manager.dart`
- **Font sizes**: Use `FontSize.sXX` from `font_manager.dart`
- **Assets**: Use `ImageAssets`, `SvgAssets`, `IconsAssets`, `JsonAssets` from `assets_manager.dart`
- **SVG rendering**: `flutter_svg` (`SvgPicture.asset`)
- **Text fields**: Use `BuildTextField` widget from `core/widget/main_text_field.dart`
- **Buttons**: Use `CustomElevatedButton` from `core/widget/custom_elevated_button.dart`
- **Validation**: Use `AppValidators` static methods from `core/widget/validators.dart`
- **Dialogs/Toasts**: Use `DialogUtils` from `core/resources/dialog_utils.dart` — `showMessageDialog()`, `showToast()`, `showLoadingDialog()`, `showSnackbar()`
- **Screens with forms**: Use `StatefulWidget` with `TextEditingController` lifecycle management (init in `initState`, dispose in `dispose`)
- **Screens without forms**: Use `StatelessWidget`

---

# Routing

- **Route names**: Defined as static const strings in `Routes` class (`core/routes_manager/routes.dart`)
- **Route generation**: `RouteGenerator.getRoute()` using `switch` on `settings.name`
- **Navigation patterns**:
    - After auth success: `Navigator.pushNamedAndRemoveUntil(context, Routes.mainRoute, (route) => false)`
    - Screen-to-screen: `Navigator.pushNamed(context, Routes.xxxRoute)`
    - Pop dialog: `Navigator.of(context).pop()`

---

# Local Storage

- **SharedPreferences** via `PrefsManager` (`core/remote/local/prefs_manager.dart`)
- Static methods: `saveToken()`, `getToken()`, `clearToken()`
- Token check at app start: `PrefsManager.getToken().isNotEmpty` determines initial route (signIn vs main)
- **Always save token** after successful authentication (both login and register)

---

# Code Generation

- **Generator**: `build_runner` with these generators:
    - `retrofit_generator` — generates Retrofit client implementations
    - `json_serializable` — generates JSON fromJson/toJson
    - `injectable_generator` — generates DI configuration
- **Command**: `dart run build_runner build` (run after modifying annotated classes)
- **Generated files**: `*.g.dart` (Retrofit, JSON) and `di.config.dart` (injectable)
- **NEVER manually edit** generated files (`*.g.dart`, `di.config.dart`)

---

# Error Handling

- **API errors** (4xx): Parsed from response body — check `statusMsg != null` then treat as error, use `message` field
- **Exception errors** (network/unexpected): Caught in DAO impl `catch(e)` then `Error(e.toString())`
- **No internet**: Checked in repo_impl before API call then `Error("No Internet Connection")`
- **UI error display**: `DialogUtils.showMessageDialog()` with "Ok" button that pops the dialog
- **UI success display**: `DialogUtils.showToast()` for success messages

---

# Key Constraints

- Do NOT introduce new packages without explicit approval
- Do NOT change the design system (colors, fonts, spacing constants) unless requested
- Analyze API responses before creating new models — reuse existing models if the response structure matches
- Always follow the existing feature structure when adding new features
- Keep domain layer clean — no framework or data-layer dependencies
- **Don't change features folders structure, just create clean architecture structure on the structure implemented**
- **Any loading widget must use shimmer**
- **Any reusable widget or widget found in listview and gridview itembuilder should be implemented in separate reusable component widget**
- **Don't create new viewmodel, use view model already created if there is a viewmodel. To handle states for every api logic separated from each other use blocbuilder buildWhen.**
- **Never create duplicate data models (DTOs) or domain entities if identical models/entities already exist in other features (e.g. CategoryDto, BrandDto, CategoryEntity, BrandEntity). Always reuse existing models and entities across features.**
