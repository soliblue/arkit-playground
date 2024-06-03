import SwiftUI

@main
struct Main: App {
    var body: some Scene {
        WindowGroup {
            NavigationView()
        }.windowStyle(.automatic)
        
        ImmersiveSpace(id: "FingerTracking") {
            FingerTrackingImmersiveView()
        }.immersionStyle(selection: .constant(.mixed))

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }.immersionStyle(selection: .constant(.mixed))
    }
}
