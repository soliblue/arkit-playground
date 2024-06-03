import SwiftUI
import ARKit
import RealityKit

struct FingerTrackingImmersiveView: View {
    private var session = ARKitSession()
    private var contentEntity = Entity()
    private var fingerEntity: ModelEntity = {
        let entity = ModelEntity(
            mesh: .generateSphere(radius: 0.005),
            materials: [SimpleMaterial(color: .cyan, isMetallic: true)],
            collisionShape: .generateSphere(radius: 0.005),
            mass: 0.0)
        entity.components.set(PhysicsBodyComponent(mode: .kinematic))
        return entity
    }()
    
    var body: some View {
        RealityView { content in
            contentEntity.addChild(fingerEntity)
            content.add(contentEntity)            
        }.onAppear {
            Task {
                // init ARKit session + request hand tracking authorization
                let authStatus = await session.requestAuthorization(for: [.handTracking])
                print("Hand Tracking Authorization Status: \(authStatus)")
                // if available on device, run hand tracking
                if HandTrackingProvider.isSupported {
                    let handTracking = HandTrackingProvider()
                    try! await session.run([handTracking])
                    for await update in handTracking.anchorUpdates {
                        if update.anchor.chirality == .right {
                            let indexFingerTipJoint = update.anchor.handSkeleton?.joint(.indexFingerTip)
                            let originFromIndexFingerTip = update.anchor.originFromAnchorTransform * indexFingerTipJoint!.anchorFromJointTransform
                            fingerEntity.setTransformMatrix(originFromIndexFingerTip, relativeTo: nil)
                            print("Index Finger Tip: \(originFromIndexFingerTip)")
                        }
                    }
                }
            }
        }
    }
}
