import SwiftUI
import SwiftData

@main
struct MyApp: App {
    @AppStorage("firstLaunch") private var firstLaunch = true
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: DeveloperEvent.self)
                .sheet(isPresented: $firstLaunch) {
                    Onboarding()
                        .modelContainer(for: Contact.self)
                        .modelContainer(for: DeveloperEvent.self)
                        .interactiveDismissDisabled()
                }
        }
    }
}
