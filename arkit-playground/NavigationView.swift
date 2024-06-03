import SwiftUI

struct NavigationView: View {
    var body: some View {
        TabView {
            FingerTrackingView()
                .tabItem {
                    Label("Finger Tracking", systemImage: "hand.point.up.fill")
                }
            WorldTrackingView()
                .tabItem {
                    Label("Head Tracking", systemImage: "head.profile.arrow.forward.and.visionpro")
                }
            HandTrackingParentView()
                .tabItem {
                    Label("Hand Tracking", systemImage: "hand.raised.fill")
                }
            SceneTrackingImmersiveView()
                .tabItem {
                    Label("Scene Tracking", systemImage: "camera.viewfinder")
                }
        }
    }
}
