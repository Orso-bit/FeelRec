//
//  ContentView.swift
//  ProgectML
//
//  Created by Giovanni Jr Di Fenza on 04/12/24.
//

import AVFoundation
import NaturalLanguage
import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) var modelContext
    @Query var storings: [Audio]
    
    @AppStorage("hasSeenInformation") private var hasSeenInformation: Bool = false
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @StateObject private var audioList = AudioList()
    @StateObject private var audioManager = AudioManager()
    @State private var isRecording = false
    @State private var recordButtonOpacity: Double = 0.6
    @State private var isAnimation = false
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        
        let largeTitleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black.withAlphaComponent(0.8)
        ]
        
        UINavigationBar.appearance().largeTitleTextAttributes = largeTitleAttributes
    }
    
    var body: some View {
        if !hasSeenInformation {
            OnboardingView()
        } else {
            NavigationStack {
                ZStack {
                    Color.accentColor
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        if audioList.items.isEmpty {
                            EmptyStateView()
                        } else {
                            RecordingListView(audioList: audioList, formattedDate: DateFormatter.formattedDate)
                        }
                        
                        RecordingView(
                            isRecording: $isRecording,
                            startRecording: startRecording,
                            stopRecording: stopRecording
                        )
                        .sensoryFeedback(.success, trigger: isRecording)
                    }
                }
                .navigationTitle("All Recordings")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: InformationView()) {
                            Image(systemName: "info.circle")
                                .foregroundStyle(Color.black)
                        }
                    }
                }
            }
            .onAppear {
                audioManager.setupAudioSession()
            }
        }
    }
    
    func startRecording() {
        if !UIAccessibility.isVoiceOverRunning {
            audioManager.setupAudioSession()
        }
        
        withAnimation {
            isRecording = true
            recordButtonOpacity = 1.0
            isAnimation = true
        }
        Task {
            await speechRecognizer.startTranscribing()
        }
    }
    
    func stopRecording() {
        if !UIAccessibility.isVoiceOverRunning {
            audioManager.setupAudioSession()
        }
        
        withAnimation {
            isRecording = false
            recordButtonOpacity = 0.6
            isAnimation = false
        }
        
        let newAudio = Audio(
            transcription: speechRecognizer.transcript,
            sentiment: speechRecognizer.sentiment,
            timestamp: Date()
        )
        
        // Insert the new audio object into the model context
        modelContext.insert(newAudio)
        
        // Commit the changes to the model context, SwiftData will handle persistence
        do {
            try modelContext.save() // Save changes
        } catch {
            print("Error saving audio to model context: \(error)")
        }
        
        // Update audioList.items by directly adding the new item (to trigger the list refresh)
        audioList.items.append(newAudio)
        
        // Stop transcription
        Task {
            await speechRecognizer.stopTranscribing()
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
