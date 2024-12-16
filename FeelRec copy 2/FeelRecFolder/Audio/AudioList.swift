//
//  AudioList.swift
//  ProjectML
//
//  Created by Giovanni Jr Di Fenza on 04/12/24.
//

import Foundation

class Audio: Identifiable {
    var id = UUID()
    var transcription: String?
    var sentiment: String
    
    init(id: UUID = UUID(), transcription: String? = nil, sentiment: String) {
        self.id = id
        self.transcription = transcription
        self.sentiment = sentiment
    }
}

class AudioList: ObservableObject {
    @Published var items: [Audio] = []
    
    func add_item(_ item: Audio) {
        items.append(item)
    }
    
    func remove_item(_ item: Audio) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {  // Usa == per confrontare UUID
            items.remove(at: index)
        }
    }
}
