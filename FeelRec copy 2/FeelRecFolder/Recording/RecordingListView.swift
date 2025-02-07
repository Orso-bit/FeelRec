//
//  RecordingListView.swift
//  FeelRec2
//
//  Created by Giovanni Jr Di Fenza on 01/02/25.
//

import SwiftUI

struct RecordingListView: View {
    @ObservedObject var audioList: AudioList
    var formattedDate: (Date) -> String
    
    var body: some View {
        List {
            Section(header: Text("List of your recordings ordered by the date")
                .font(.system(size: 18))) {
                ForEach(audioList.items) { audio in
                    if let transcription = audio.transcription, !transcription.isEmpty {
                        VStack {
                            HStack {
                                Text(formattedDate(audio.timestamp))
                                    .font(.system(size: 17))
                                    .foregroundStyle(Color.gray)
                                Spacer()
                            }
                            Divider()
                            HStack {
                                Text(transcription)
                                    .font(.body)
                                    .foregroundStyle(Color.black)
                                Spacer()
                                Text(audio.sentiment ?? "")
                                    .font(.body)
                                    .foregroundColor(.blue)
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        audioList.remove_item(audioList.items[index])
                    }
                }
            }
            .listRowBackground(Color("Color"))
        }
        .listRowSpacing(30.0)
        .scrollContentBackground(.hidden)
        .background(Color.accentColor)
    }
}
