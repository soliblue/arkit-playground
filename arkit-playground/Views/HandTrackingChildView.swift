import SwiftUI
import ARKit

struct HandTrackingChildView: View {
    // arguments
    private var side: HandAnchor.Chirality
    private var provider: HandTrackingProvider
    // internal state
    private var timeGap: Double = 1
    private var movementGap: Float = 0.05
    @State private var handPosition: Float = 0
    @State private var handMovedTime: Date = Date()
    
    init(side: HandAnchor.Chirality, provider: HandTrackingProvider) {
        self.side = side
        self.provider = provider
    }
    
    var body: some View {
        VStack(spacing: 10){
            Circle()
                .frame(width: 250, height: 250)
                .foregroundColor(handMovedTime.timeIntervalSinceNow > -timeGap ? .green : .white)
            Text("Hand Position: \(handPosition, specifier: "%.2f")")
            Text("Hand Moved: \(handMovedTime.timeIntervalSinceNow > -timeGap ? "Yes" : "No")")
        }
        .onAppear {
            Task {
                for await update in provider.anchorUpdates {
                    if let newHandPosition = update.anchor.chirality == side ? update.anchor.originFromAnchorTransform.columns.3.y : nil {
                        if newHandPosition > handPosition {
                            handPosition = newHandPosition
                        } else if newHandPosition < handPosition - movementGap {
                            handPosition = newHandPosition
                            handMovedTime = Date()
                        }
                    }
                }
            }
        }
    }
}
