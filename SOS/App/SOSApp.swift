import SwiftUI

@main
struct SOSApp: App {
    @State private var store = SettingsStore()
    @State private var location = LocationService()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(store)
                .environment(location)
                .tint(.sosRed)
                .onOpenURL { url in
                    if url.scheme == SOSLink.trigger.scheme {
                        SOSCoordinator.shared.request()
                    }
                }
        }
    }
}

struct RootView: View {
    @Environment(SettingsStore.self) private var store

    var body: some View {
        ZStack {
            if store.prefs.hasOnboarded {
                HomeView()
                    .transition(.opacity)
            } else {
                OnboardingView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.35), value: store.prefs.hasOnboarded)
    }
}
