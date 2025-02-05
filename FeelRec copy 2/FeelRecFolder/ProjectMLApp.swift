//
//  ProgectMLApp.swift
//  ProgectML
//
//  Created by Giovanni Jr Di Fenza on 04/12/24.
//

import SwiftUI
import SwiftData

@main
struct YourApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Audio.self)
        }
    }
}
