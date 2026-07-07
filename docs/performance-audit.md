# Performance and Memory Audit

Date: 2026-07-07  
Device: iPhone 17 Pro Simulator  
Configuration: Debug  
Tools: Xcode Memory Graph Debugger, Instruments Leaks, Instruments Allocations, Instruments Time Profiler

## Scope

This audit validates the runtime behavior of the main currency rate flow:

- Rate list loading
- Amount input updates
- Currency picker presentation and dismissal
- Currency search
- Currency selection transition
- Pull-to-refresh
- Repeated navigation between the rate list and currency picker

## Scenario

The following interaction scenario was used during profiling:

1. Launch the application.
2. Wait for the rate list to load.
3. Open the currency picker.
4. Search for currencies and clear the search input.
5. Select a currency and return to the rate list.
6. Repeat the currency picker flow multiple times.
7. Trigger pull-to-refresh.
8. Enter and delete amount values.
9. Wait for the app to become idle.

## Memory Graph

Xcode Memory Graph Debugger was used after repeatedly opening and dismissing the currency picker.

Observed object counts after returning to the rate list:

| Object | Count | Expected |
| --- | ---: | --- |
| `RateListViewController` | 1 | Yes |
| `RateListViewModel` | 1 | Yes |
| `RateListCoordinator` | 1 | Yes |
| `CurrencyPickerTransitionAnimator` | 1 | Yes |
| `CurrencyPickerViewController` | 0 | Yes |
| `CurrencyPickerViewModel` | 0 | Yes |
| `CurrencyPickerCoordinator` | 0 | Yes |

Additional retained root-flow objects were expected:

- `RateListHeaderView`
- Visible/reusable `RateListCell` instances
- Repository and cache dependencies
- Networking client

Result:

- No retained dismissed currency picker screen was observed.
- No retained currency picker view model was observed.
- No retained currency picker coordinator was observed.
- Coordinator cleanup behaved as expected.

## Leaks

Instruments Leaks was run during repeated currency picker, search, selection, refresh, and amount-input interactions.

Observed result:

- 8 small leaks were reported by Instruments.
- None of the reported leak stacks were associated with `ForexApp`, `RatesFeature`, `RateList`, `CurrencyPicker`, coordinator, view model, or repository code.
- The reported leaks were treated as simulator/system-framework noise.

Result:

- No app-owned leak was detected.

## Allocations

Instruments Allocations was run for a 2m55s interaction scenario.

| Measurement | Value |
| --- | ---: |
| Initial stable memory | 20.52 MiB |
| Memory after scenario | 42.33 MiB |

Observed behavior:

- Memory increased during initial loading and interaction.
- Memory stabilized after repeated interactions.
- No repeated upward allocation pattern was observed.
- App-specific allocation entries were small.
- Persistent allocations were dominated by system/UIKit/CoreAnimation categories rather than app-owned objects.

Result:

- Allocation behavior was stable for the tested scenario.

## Time Profiler

Instruments Time Profiler was run during amount input, currency search, currency picker transitions, currency selection, and refresh interactions.

Top app-related frames:

| Symbol | Time | Percentage |
| --- | ---: | ---: |
| `CurrencyPickerViewController.apply(items:)` | 477 ms | 5.0% |
| `RateListViewController.apply(items:)` | 424 ms | 4.4% |
| `CurrencyPickerTransitionAnimator.preparePushDestination(_:using:)` | 191 ms | 2.0% |

Observed behavior:

- No app-owned hot path dominated main-thread execution.
- Diffable data source apply paths appeared as expected during list/search updates.
- Transition preparation remained low.
- No visible UI stutter was observed during the tested interactions.

Result:

- No runtime performance bottleneck was identified in the tested flow.

## Runtime Diagnostics

Runtime console output was reviewed while running the app with Xcode diagnostics.

Observed warnings included simulator/system messages related to:

- PointerUI
- Keyboard and dictation UI
- Simulator haptic pattern data
- Text input prediction constraints

No warnings were traced to app-owned views or layout code such as:

- `RateListHeaderView`
- `RateListCell`
- `CurrencyPickerCell`
- `RateListViewController`
- `CurrencyPickerViewController`

Result:

- No app-owned Main Thread Checker issue was observed.
- No app-owned Auto Layout constraint issue was observed.

## Code Audit Follow-up

A lifecycle cleanup was added to cancel the rate-list loading task when `RateListViewController` is deallocated.

Result:

- The change prevents unnecessary async work from continuing after the screen is released.
- This was a lifecycle cleanup, not a confirmed memory-leak fix.

## Conclusion

The profiled runtime flow did not show app-owned memory leaks, retained dismissed screens, runaway allocations, or main-thread performance bottlenecks.

The main rate list and currency picker flows are considered healthy for the tested Debug simulator scenario.
