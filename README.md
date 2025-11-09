# 🐉 DragonBall Characters – iOS Clean Architecture

A sample iOS app that lists **Dragon Ball characters** using a real API:
👉 [https://dragonball-api.com/api/characters](https://dragonball-api.com/api/characters)

This project demonstrates how to design a **scalable, testable, and offline-capable** mobile architecture using **SwiftUI**, **Clean Architecture**, **MVVM**, and **Repository Pattern** — with Core Data for local caching and Alamofire for networking.

---

## 🧱 Architecture Overview

```
├── Core
│   ├── NetworkManager.swift
│   ├── ImageCacheService.swift
│   └── Persistence/CoreDataStack.swift
│
├── Data
│   ├── DataSources
│   │   ├── LocalDataSource.swift
│   │   └── RemoteDataSource.swift
│   ├── Repositories
│   │   └── CharactersRepositoryImpl.swift
│   ├── DTOs
│   │   ├── CharacterDTO.swift
│   │   └── CharactersResponseDTO.swift
│
├── Domain
│   ├── Entities/Character.swift
│   ├── UseCases
│   │   ├── FetchCharactersUseCase.swift
│   │   └── RefreshCharactersUseCase.swift
│   └── RepositoryProtocols/CharactersRepositoryProtocol.swift
│
├── Presentation (SwiftUI)
│   ├── ViewModels
│   │   ├── CharactersListViewModel.swift
│   │   └── CharacterDetailViewModel.swift
│   └── Views
│       ├── CharactersListView.swift
│       ├── CharacterRowView.swift
│       └── CharacterDetailView.swift
│
└── DI
    └── AppContainer.swift
```

---

## 🧠 Clean Architecture Breakdown

| Layer            | Responsibility                            | Example                                                           |
| ---------------- | ----------------------------------------- | ----------------------------------------------------------------- |
| **Presentation** | UI logic (SwiftUI) + state (MVVM) | `CharactersListViewModel`, `CharactersListView`                   |
| **Domain**       | Business logic (Use Cases + Entities)     | `FetchCharactersUseCase`, `Character`                             |
| **Data**         | Data handling (Repositories + Sources)    | `CharactersRepositoryImpl`, `RemoteDataSource`, `LocalDataSource` |
| **Core**         | Shared system-level components            | `NetworkManager`, `CoreDataStack`, `ImageCacheService`            |

✅ The **Presentation layer** only depends on the **Domain layer**.
✅ The **Domain layer** depends on **no one** (pure business logic).
✅ The **Data layer** depends on **Core** for concrete implementations.

---

## 🚀 Features


|<img width="1206" height="2622" alt="simulator_screenshot_A69D4C74-3C16-426A-888B-6D77159DBF7E" src="https://github.com/user-attachments/assets/1acf20a4-a681-469b-bcde-b5a4b677e228" /> |![simulator_screenshot_FA54740C-63EA-4B47-BDF4-899FAED62B9D](https://github.com/user-attachments/assets/29563436-e256-4e17-a0b3-29abeadd3ba9)|
|---|---|


### Functional Requirements

* Fetches characters from [Dragon Ball API](https://dragonball-api.com/api/characters)
* Supports **pagination** (auto-load next page when scrolling)
* **Pull to refresh** (resets cache and reloads)
* **Offline support** — cached via Core Data + image cache
* Shared repository and use cases across SwiftUI and UIKit
* Reusable networking (Alamofire-based)

### Non-functional Requirements

* Optimized Core Data fetching with pagination (fetchOffset + fetchLimit)
* Thread-safe async Core Data operations (`@MainActor` + background contexts)
* Strong modularization and dependency injection
* Unit test–ready architecture
* Minimal memory footprint with Core Data fetch batching

### Out of Scope

* Authentication / profile management
* Push notifications
* API mutation (write operations)

---

## 🧩 Core Design Decisions

| Decision               | Reason                                                                                                               |
| ---------------------- | -------------------------------------------------------------------------------------------------------------------- |
| **Alamofire**          | Simplifies async networking, error handling, and JSON decoding. Alternative: `URLSession` (more verbose but native). |
| **Core Data**          | Robust offline persistence and batch operations. Alternative: `Realm`, `SQLite`, or `SwiftData`.                     |
| **MVVM**               | Natural fit for SwiftUI with reactive data binding.                                                                  |
| **Clean Architecture** | Enables strict separation of concerns for scalability and testability.                                               |
| **Async/Await**        | Simplifies concurrency management with structured tasks.                                                             |

---

## ⚙️ Tech Stack

| Layer                    | Technology                             |
| ------------------------ | -------------------------------------- |
| **Language**             | Swift 5.9                              |
| **UI**                   | SwiftUI (UIKit equivalent planned)     |
| **Networking**           | Alamofire                              |
| **Persistence**          | Core Data                              |
| **Architecture**         | Clean Architecture + MVVM + Repository |
| **Dependency Injection** | Resolver / manual DI container         |
| **Concurrency**          | Structured Concurrency (async/await)   |
| **Testing**              | XCTest (UseCase & Repository layers)   |

---

## 🧩 Core Highlights

### 🧠 NetworkManager (Alamofire)

* Single reusable class with typed responses
* Alternate implementation available using `URLSession` for system design comparison

### 💾 LocalDataSource (Core Data)

* Optimized fetching via `fetchBatchSize`, `fetchLimit`, and `fetchOffset`
* Background context operations merged to main view context
* Defensive async-safe design using continuations and merge notifications

### ⚙️ Repository Pattern

* Handles data orchestration between **remote** and **local** sources
* Defines single interface for all data consumers
* Implements cache-first read, remote sync, and offline fallback

### 🌐 Pagination + Refresh

* `loadNextPageIfNeeded(currentItem:)` for smooth infinite scrolling
* `refresh()` clears local store and re-fetches from page 1
* Safe concurrency handling to prevent overlapping async operations

---

## 🧪 How to Run

1. Clone the repo:

   ```bash
   git clone https://github.com/<yourname>/DragonBallChars.git
   cd DragonBallChars
   ```

2. Open the project:

   ```
   open DragonBallChars.xcodeproj
   ```

3. Install Swift Package dependencies (Alamofire).

4. Build and Run (`⌘ + R`).

---

## 🧱 Offline Behavior

* The app automatically caches characters and images.
* On subsequent launches or offline state:

  * Core Data serves previously cached entities.
  * ImageCacheService loads stored images from memory/disk.

---

## 🔐 Error Handling Strategy

| Error Type          | Strategy                                        |
| ------------------- | ----------------------------------------------- |
| **Network Failure** | Retry or fall back to local cache               |
| **Decoding Error**  | Logs failure with contextual info               |
| **Core Data Error** | Graceful fallback + safe continuations          |
| **Race Conditions** | Serialized background operations + mergeChanges |

## 🧩 License

MIT License — feel free to use or fork this for learning or demonstration.
