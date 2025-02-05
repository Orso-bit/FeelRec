//
//  AudioList.swift
//  ProjectML
//
//  Created by Giovanni Jr Di Fenza on 04/12/24.
//

import Foundation
import SwiftData

@Model
class Audio: Identifiable {
    var id = UUID()
    var transcription: String?
    var sentiment: String?
    var timestamp: Date
    
    init(id: UUID = UUID(), transcription: String? = nil, sentiment: String, timestamp: Date = Date()) {
        self.id = id
        self.transcription = transcription
        self.sentiment = sentiment
        self.timestamp = timestamp
    }
}

class AudioList: ObservableObject {
    @Published var items: [Audio] = []
    
    func add_item(_ item: Audio) {
        items.append(item)
    }
    
    func remove_item(_ item: Audio) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items.remove(at: index)
        }
    }
}
