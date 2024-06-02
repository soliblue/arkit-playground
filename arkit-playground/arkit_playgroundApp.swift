//
//  arkit_playgroundApp.swift
//  arkit-playground
//
//  Created by Soli on 02.06.24.
//

import SwiftUI

@main
struct arkit_playgroundApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.windowStyle(.volumetric)

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }.immersionStyle(selection: .constant(.progressive), in: .progressive)
    }
}
