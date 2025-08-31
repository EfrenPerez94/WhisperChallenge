# PokemonAnalyticsApp

The following project is part of an assignment for iOS developers. It is intended to evaluate:

- Code / project organization  
- Swift fundamentals (Swift Concurrency, Combine, SwiftUI interop)  
- Architecture and design (UIKit + Coordinators + MVVM + SwiftUI)  
- Error handling & retry  
- Caching and/or persistence 
- Basic analytics/visualization 
- UI built with UIKit and SwiftUI 
- Use of Auto Layout programmatically 

The application retrieves Pokémon data from the public **PokeAPI** and provides:
- A **Pokédex list** with search/pagination  
- A **Detail screen** per Pokémon (types, stats, image, Catch/Release)  
- A **Caught** tab showing persisted caught Pokémon  
- An **Insights** tab with simple charts (donut/bar) based on current data

---

## Requirements

- **Xcode** 16.x or later  
- **iOS** 17.0+ (Deployment Target configurable)  
- **Swift Package Manager**
  
---

## App Architecture

**Pattern:** *UIKit Coordinators + MVVM + SwiftUI embedding*

- **UIKit as the app shell**: navigation via `UINavigationController` and `UITabBarController`.  
- **Coordinators**: composition root, dependency injection (API service, model container), and screen flow.  
- **MVVM**: `ViewModel`s expose state as `@Published RequestState<T>`; views render `idle/fetching/loaded/failed`.  
- **SwiftUI**: feature screens built in SwiftUI, embedded with `UIHostingController` from Coordinators.  
- **Networking**: `URLSessionHTTPClient` + `PokeAPIService`.  
- **Persistence**: **SwiftData** (`CaughtPokemon`) for caught Pokémon.  
- **Caching**: `URLCache` configured in `NetworkConfig`.  
- **Error handling**: unified via `AppError`, user-visible retry in UI.  
- **Auto Layout**: small UIKit components with **NSLayoutConstraints** (e.g., an `ErrorBannerView` or a floating button).  
- **Charts**: **Swift Charts** in **Insights** to visualize distribution/types/stats.

---

## Networking

- **Endpoints** (PokeAPI):
  - List: `/pokemon?offset=&limit=`
  - Detail: `/pokemon/{id}`
- **Caching**: `URLCache` sized for list/detail calls.

### Simulated failure (DEBUG only)

To demonstrate error handling + retry, the HTTP client supports a **one-shot** simulated failure in DEBUG:
- When enabled, the first request throws error.

---

## Persistence (SwiftData)

- Model: `CaughtPokemon` persisted locally.  
- **Catch/Release** toggled in the Detail screen; updates reflect in **Caught** tab.

---

## Swift Charts (Insights)

- Example charts:
  - **Donut**
  - **Bar**
- Data is computed from in-app models without hitting extra endpoints.

---

## Run Project
- If you are running the project for the first time:
  - Open in Xcode
  - Open PokemonAnalyticsApp.xcodeproj.
  - Select a Simulator
  - Build & Run
  - 
- Note: Swift Package Manager will resolve packages automatically on first build. No CocoaPods needed.

---
## Unit Tests
- HTTPClientTests: request execution and error mapping.
- PokemonDetailViewModelTests: state transitions (fetching → loaded/failed).
- CaughtPokemonTests: persistence logic.
  
## UI Test
- PokedexFlowUITests.
  - Toogle catch from PokedexView And Verify in CaughtView
    - Waits for Pokédex list
    - Opens Detail of the first item
    - Ensures Catch 
    - Navigates to Caught tab and verifies there is at least one item

---

## Contributing
Please follow standard GitHub guidelines when contributing:
- [Git Contributing Guidelines](https://github.com/wizeline/wize-docs/blob/master/development/git-contributing-guidelines.md)

## DEMO
- Attached to the repo you will find a video of the current behaviour of the app.

THANKS FOR READING :)




