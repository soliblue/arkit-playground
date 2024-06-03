import SwiftUI
import ARKit

struct HandTrackingParentView: View {
    private var session = ARKitSession()
    @State var provider: HandTrackingProvider?
    
    var body: some View {
        VStack(spacing: 20){
            Text("ARKit Playground").font(.largeTitle)
            Text("Hand Tracking").font(.title).foregroundColor(.gray)
            Divider()
            if let provider = provider {
                HStack(spacing: 20){
                    HandTrackingChildView(side: .left, provider: provider)
                    HandTrackingChildView(side: .right, provider: provider)
                }
            }
            Divider()
        }.onAppear {
            Task {
                // init ARKit session + request hand tracking authorization
                let authStatus = await session.requestAuthorization(for: [.handTracking])
                print("Hand Tracking Authorization Status: \(authStatus)")
                // if available on device, run hand tracking
                if HandTrackingProvider.isSupported {
                    let handTracking = HandTrackingProvider()
                    try! await session.run([handTracking])
                    provider = handTracking
                }
            }
        }
    }
}
