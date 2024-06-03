import SwiftUI
import RealityKit

struct ImmersiveViewToggle: View {
    var id: String
    
    @State private var immersiveSpaceIsOpen = false
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    var body: some View {
        VStack {
            HStack {
                Text("Immersive View").font(.largeTitle)
                Button(action: {
                    immersiveSpaceIsOpen.toggle()
                    Task {
                        if immersiveSpaceIsOpen {
                            await openImmersiveSpace(id: id)
                        } else {
                            await dismissImmersiveSpace()
                        }
                    }
                    
                }) {
                    Image(systemName: immersiveSpaceIsOpen ? "xmark" : "arrow.up.left.and.arrow.down.right")
                }
            }
            Text("Toggle immersive view to use the data provider")
            
        }
        
    }
}

#Preview (windowStyle: .automatic) {
    ImmersiveViewToggle(id: "ImmersiveViewToggle")
}
