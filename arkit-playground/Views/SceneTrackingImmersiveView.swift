import ARKit
import SwiftUI
import RealityKit

struct SceneTrackingImmersiveView: View {
    private var session = ARKitSession()
    @State private var provider: SceneReconstructionProvider?
    // object to store entities: id -> entity
    @State private var content: RealityViewContent?
    @State private var entities: [UUID: Entity] = [:]
    
    var body: some View {
        RealityView {content in
            self.content = content
        }.onAppear {
            Task {
                // init ARKit session + request hand tracking authorization
                let authStatus = await session.requestAuthorization(for: [.worldSensing])
                print("Head Tracking Authorization Status: \(authStatus)")
                // if available on device, run head tracking
                if SceneReconstructionProvider .isSupported {
                    let sceneReconstruction = SceneReconstructionProvider()
                    try! await session.run([sceneReconstruction])
                    provider = sceneReconstruction
                    if let provider = provider {
                        for await update in provider.anchorUpdates {
                            let shape = try! await ShapeResource.generateStaticMesh(from: update.anchor)
                            switch update.event {
                            case .added:
                                print("Scene Reconstruction Anchor Added: \(update)")
                                let entity = ModelEntity()
                                entity.transform = Transform(matrix: update.anchor.originFromAnchorTransform)
                                entity.collision = CollisionComponent(shapes: [shape], isStatic: true)
                                entity.components.set(InputTargetComponent())
                                entity.physicsBody = PhysicsBodyComponent(mode: .static)
                                entities[update.anchor.id] = entity
                                content!.add(entity)
                            case .updated:
                                continue
                                // print("Scene Reconstruction Anchor Updated: \(update)")
                            case .removed:
                                entities[update.anchor.id]?.removeFromParent()
                                entities.removeValue(forKey: update.anchor.id)
                            }
                        }
                    }
                }
            }
        }
    }
}
