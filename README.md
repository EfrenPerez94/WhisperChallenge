content = """# PokemonAnalyticsApp

The following project is part of an assignment for iOS developers. It is intended to evaluate:

- Code / project organization  
- Swift fundamentals (Swift Concurrency, Combine, SwiftUI interop)  
- Architecture and design (UIKit + Coordinators + MVVM + SwiftUI)  
- Error handling & retry  
- Caching and/or persistence  
- Basic analytics/visualization (Swift Charts)  
- UI built with UIKit and SwiftUI (via `UIHostingController`)  
- Use of Auto Layout programmatically (NSLayoutConstraints)

The application retrieves Pokémon data from the public **PokeAPI** and provides:
- A **Pokédex list** with search/pagination  
- A **Detail screen** per Pokémon (types, stats, image, Catch/Release)  
- A **Caught** tab showing persisted caught Pokémon  
- An **Insights** tab with simple charts (donut/bar) based on current data

---

## Requirements

- **Swift** 5.9 or later  
- **Xcode** 15.x or later  
- **iOS** 17.0+ (Deployment Target configurable)  
- **Swift Package Manager** (no CocoaPods required)  
- **SwiftLint** (optional but recommended; config included via `.swiftlint.yml`)

> If you don’t have SwiftLint installed:  
> ```bash
> brew install swiftlint
> ```

---

## Project Structure

PokemonAnalyticsApp/
├─ App/
│ ├─ UIKitRootView.swift
│ ├─ AppCoordinator.swift // UIKit + Coordinator (composition root)
│ └─ Tabs/ (Pokedex, Caught, Insights tab setup)
├─ Network/
│ ├─ HTTPClient.swift // URLSessionHTTPClient, one-shot failure in DEBUG
│ ├─ NetworkConfig.swift // URLCache, JSONDecoder, baseURL
│ └─ PokeAPIService.swift // Endpoints: list, detail
├─ Models/
│ ├─ PokemonsListModel.swift
│ ├─ PokemonDetailModel.swift
│ └─ CaughtPokemon.swift // SwiftData model
├─ ViewModels/
│ ├─ PokedexListViewModel.swift
│ ├─ PokemonDetailViewModel.swift
│ └─ Common/RequestState.swift, AppError.swift
├─ Views/
│ ├─ PokedexListView.swift
│ ├─ PokemonDetailView.swift
│ ├─ CaughtView.swift
│ ├─ InsightsView.swift // Swift Charts (donut/bar)
│ └─ UIKit/ // UIKit views using Auto Layout (e.g., ErrorBanner)
├─ Resources/
│ ├─ Assets.xcassets
│ └─ Info.plist
├─ Tests/
│ ├─ Unit/
│ │ ├─ HTTPClientTests.swift
│ │ ├─ PokemonDetailViewModelTests.swift
│ │ └─ CaughtPokemonTests.swift
│ └─ UI/
│ └─ PokedexFlowUITests.swift // UI test: List → Detail → Catch → Caught → Insights
└─ .swiftlint.yml
Always show details


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
  - Detail: `/pokemon/{id|name}`
- **HTTP client**: `URLSessionHTTPClient` centralizes request execution and error mapping.
- **Decoding**: `JSONDecoder` configured in `NetworkConfig`.
- **Caching**: `URLCache` sized for list/detail calls.

### Simulated failure (DEBUG only)

To demonstrate error handling + retry, the HTTP client supports a **one-shot** simulated failure in DEBUG:
- When enabled, the first request throws `URLError(.notConnectedToInternet)` mapped to `AppError.network`.
- Subsequent requests proceed normally (flag consumed).

---

## Error Handling & Retry

- **State machine**:  
  `RequestState<Value> = .idle / .fetching / .loaded(Value) / .failed(AppError)`  
- **UI**: on `.failed`, screens present a friendly message and a **Retry** button.  
- **Banner (UIKit + Auto Layout)**: Optional `ErrorBannerView` shows an error at the top of the screen, added to the current VC and constrained with `NSLayoutConstraint.activate([top/leading/trailing])`.

---

## Persistence (SwiftData)

- Model: `CaughtPokemon` persisted locally.  
- **Catch/Release** toggled in the Detail screen; updates reflect in **Caught** tab.

---

## Swift Charts (Insights)

- Example charts:
  - **Donut**: composition by types of caught/favorites.  
  - **Bar**: top stats sum per Pokémon.  
- Data is computed from in-app models without hitting extra endpoints.

---

## SwiftLint

The repo includes a `.swiftlint.yml`. If you want linting in builds, add a Run Script phase like:

```bash
if which swiftlint >/dev/null; then
  swiftlint
else
  echo "warning: SwiftLint not installed; run 'brew install swiftlint'"
fi
Run Project
If you are running the project for the first time:
Open in Xcode
Open PokemonAnalyticsApp.xcodeproj (or workspace if you use one).
Select a Simulator
e.g., iPhone 15 / iOS 17+.
Build & Run
⌘R
Note: Swift Package Manager will resolve packages automatically on first build. No CocoaPods needed.
Run Tests
From Xcode: ⌘U (runs Unit + UI tests).
From CLI (example):
Always show details

xcodebuild \
  -scheme PokemonAnalyticsApp \
  -destination 'platform=iOS Simulator,name=iPhone 15,OS=17.5' \
  clean test
Unit Tests
HTTPClientTests: request execution and error mapping.
PokemonDetailViewModelTests: state transitions (fetching → loaded/failed).
CaughtPokemonTests: persistence logic.
UI Test
PokedexFlowUITests.test_HappyPath_ListToDetail_ToggleCatch_VerifyInCaught_ThenInsights
Waits for Pokédex list
Opens Detail of the first item
Ensures Catch → Release state (caught)
Navigates to Caught tab and verifies there is at least one item
Navigates to Insights and verifies the screen is present
Accessibility Identifiers used (ensure they exist in code):
CatchReleaseButton (detail screen button)
Tab titles: Pokedex, Caught, Insights (as tabBarItem.title)
(Optional) Simulate Network Failure (DEBUG)
If you want to demonstrate the retry flow quickly:
In the composition root (where you create the HTTP client):
Always show details

let http = URLSessionHTTPClient()
#if DEBUG
http.simulateError = true   // one-shot failure
#endif
self.api = PokeAPIService(httpClient: http)
Alternatively, enable it only when launching tests with a launch argument:
Always show details

let args = ProcessInfo.processInfo.arguments
http.simulateError = args.contains("UITEST_FAIL_ONCE")
Then launch with:
Always show details

xcodebuild ... -only-testing:PokemonAnalyticsAppUITests \
  -testArguments "-UITEST_FAIL_ONCE"
On the first request you’ll see the error UI; tapping Retry should then load successfully.
App Architecture (Short Rationale)
UIKit shell + Coordinators make navigation and dependency injection explicit and testable.
MVVM keeps UI rendering simple while ViewModels own async work/state.
SwiftUI accelerates building feature screens while reusing UIKit navigation.
SwiftData is a lightweight persistence layer suitable for local “caught” state.
Swift Charts provides quick insight visualizations without extra dependencies.
Auto Layout (NSLayoutConstraints) demonstrates UIKit fundamentals and interop.
Contributing
Please follow standard GitHub guidelines when contributing:
Fork → feature branch → PR
Write tests for new behavior
Keep code linted and passing
Notes / Future Work
Infinite scrolling + smarter prefetching on list
Image caching/memoization per detail
More insights (scatter/radar per stat)
Theming & accessibility tuning (Dynamic Type, VoiceOver labels)
"""
path = "/mnt/data/README.md"
with open(path, "w", encoding="utf-8") as f:
f.write(content)
path
