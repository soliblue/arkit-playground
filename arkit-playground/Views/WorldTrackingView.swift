import SwiftUI
import ARKit

struct WorldTrackingView: View {
    private var session = ARKitSession()
    @State private var position: Float = 0
    @State private var provider: WorldTrackingProvider?
    
    var body: some View {
        VStack(spacing: 20){
            Text("ARKit Playground").font(.largeTitle)
            Text("Head Tracking").font(.title).foregroundColor(.gray)
            Divider()
            Text("Head Position: \(position, specifier: "%.2f")")
            Button("Track Head Position") {
                if let provider = provider {
                    position = provider.queryDeviceAnchor(atTimestamp: CACurrentMediaTime())?.originFromAnchorTransform.columns.3.y ?? 0
                }
            }
        }.onAppear {
            Task {
                // init ARKit session + request hand tracking authorization
                let authStatus = await session.requestAuthorization(for: [.worldSensing])
                print("Head Tracking Authorization Status: \(authStatus)")
                // if available on device, run head tracking
                if WorldTrackingProvider.isSupported {
                    let worldTracking = WorldTrackingProvider()
                    try! await session.run([worldTracking])
                    provider = worldTracking
                }
            }
        }
    }
}
