import SwiftUI
import ARKit
import RealityKit

struct FingerTrackingView: View {
    var body: some View {
        VStack(spacing: 20){
            Text("ARKit Playground").font(.extraLargeTitle)
            Text("Finger Tracking").font(.extraLargeTitle2)
            Spacer()
            Divider().background(Color.white)
            ImmersiveViewToggle(id: "FingerTrackingView")
            Divider().background(Color.white)
            Spacer()
        }.padding()
    }
}

#Preview(windowStyle: .automatic){
    FingerTrackingView()
}
