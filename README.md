# Zepto Clone

A simplified Zepto-like grocery delivery app built with Flutter, following Clean Architecture principles.

## Features

- **Products**: Browse available grocery products
- **Cart**: Add products to cart, update quantities, remove items
- **Admin**: Add new products (bonus feature)

## Architecture

This app follows **Clean Architecture** with 3 layers:

1. **Data Layer**: Models, Data Sources (Firebase), Repositories
2. **Domain Layer**: Entities, Repositories (abstract), Use Cases
3. **Presentation Layer**: UI, State Management (Riverpod StateNotifier)

## Tech Stack

- **Flutter**: UI framework
- **Riverpod**: State management (StateNotifier only)
- **Firebase Cloud Firestore**: Backend database
- **GetIt**: Dependency injection
- **Equatable**: Value equality
- **Dartz**: Functional programming (Either for error handling)

## Folder Structure

```
lib/
├── core/                    # Core utilities (failures, usecase)
├── config/                  # Dependency injection setup
├── data/                    # Firebase service wrapper
├── features/
│   ├── products/            # Products feature
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── state_management/
│   │       ├── views/
│   │       └── widgets/
│   ├── cart/                # Cart feature
│   │   └── ... (same structure)
│   └── admin/               # Admin feature
│       └── ... (same structure)
├── presentation/            # Shared presentation
├── shared/                  # Shared widgets
└── main.dart
```

## Setup

1. **Install dependencies**:
   ```bash
   flutter pub get
   ```

2. **Firebase Setup**:
   - Create a Firebase project
   - Enable Cloud Firestore
   - Add your Firebase config to the app
   - For this demo, the app uses hardcoded user 'user1' for cart

3. **Run the app**:
   ```bash
   flutter run
   ```

## Firebase Data Structure

### Products Collection
```json
{
  "id": "string",
  "name": "string",
  "description": "string",
  "price": double,
  "imageUrl": "string",
  "category": "string",
  "isAvailable": boolean
}
```

### Cart Collection (under users/user1/cart)
```json
{
  "product": { /* ProductModel */ },
  "quantity": int
}
```

## State Management

Each feature uses Riverpod with StateNotifier:

- **State**: Immutable, extends Equatable
- **Notifier**: Calls use cases, emits states
- **Provider**: Exposes notifier

States: initial, loading, loaded, error

## Error Handling

Uses `Either<Failure, T>` for all operations. Failures are converted to user-friendly messages in the UI.

## Dependency Injection

GetIt is used to register dependencies in order:

1. Firebase service
2. Data sources
3. Repositories
4. Use cases
5. Notifiers (handled by Riverpod)

## UI

- Material 3 design
- Clean, minimal interface
- Reusable widgets
- No business logic in UI components

## Development

- Follow Clean Architecture strictly
- No layer violations
- Firebase logic only in data sources
- UI calls use cases only
- Each action has a dedicated use case
