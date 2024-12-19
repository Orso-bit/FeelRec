//
//  ContentView.swift
//  ProgectML
//
//  Created by Giovanni Jr Di Fenza on 04/12/24.
//

import NaturalLanguage
import SwiftUI
import AVFoundation

struct ContentView: View {
    
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @StateObject private var audioList = AudioList()
    @State var isRecording = false
    @State private var recordButtonOpacity: Double = 0.6
    @State private var isAnimation = false  // Controls animation
    @State private var searchText: String = ""
    
    func currentTime() -> String {
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let theDate = "\(day)/\(month)/\(year) \(hour):\(minute)"
        
        return theDate
    }
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.color]
        
        UISearchBar.appearance().tintColor = UIColor(Color("Color"))
        UISearchBar.appearance().searchTextField.backgroundColor = UIColor(Color("Color 1"))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.accentColor
                    .edgesIgnoringSafeArea(.all)
            VStack {
                if audioList.items.isEmpty {
                    VStack {
                        Spacer()
                        // Show image and text if no audio
                        Image(systemName: "archivebox")
                            .resizable()
                            .foregroundStyle(Color.color1)
                            .frame(width: 70, height: 65)
                            .padding()
                        Text("No Recordings")
                            .foregroundStyle(Color.color)
                            .font(.title)
                            .bold()
                        Text("Tap the Record button to start FeelRec")
                            .foregroundStyle(Color.color)
                            .font(.title3)
                            .fontWeight(.regular)
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(audioList.items) { audio in
                            // Limit words to make list more readable
                            if let transcription = audio.transcription, !transcription.isEmpty {
                                VStack {
                                    NavigationLink(destination: EmotionView(sleepModel: SleepModel())) {
                                        Text(currentTime())
                                            .foregroundStyle(.gray)
                                    }
                                    Divider()
                                    HStack {
                                        Text(transcription)
                                            .font(.body)
                                            .foregroundStyle(Color.black)
                                        Spacer()
                                        Text("\(audio.sentiment)")
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
                        .listRowBackground(Color("Color"))
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color("Color 1"))
                    .searchable(text: $searchText)
                }
                
                // Audio Waves if the button is tapped
                HStack {
                    ForEach(0..<38) { item in
                        RoundedRectangle(cornerRadius: 2)
                            .frame(width: 2, height: .random(in: 4...45))
                            .foregroundStyle(Color.color)
                            .animation(
                                isRecording ?
                                    .easeInOut(duration: 0.4)
                                    .repeatForever(autoreverses: true) :
                                    .default, // Add default animation when not recording
                                value: isRecording
                            ) // Animation controlled by `isRecording`
                    }
                }
                .padding(.bottom, 20)
                
                // Record button
                Button(action: {
                    if isRecording {
                        // Stop recording and stop animation
                        stopRecording()
                    } else {
                        // Start recording and start animation
                        startRecording()
                    }
                }) {
                    ZStack {
                        Image(systemName: isRecording ? "stop.circle" : "play.circle")
                            .resizable()
                            .frame(width: 70, height: 70)
                            .foregroundStyle(isRecording ? Color.gray : Color("Color 2"))
                        }
                    }
                }
            }
            .navigationTitle("All Recordings")
        }
        .onAppear {
            setupAudioSession()
        }
    }
    
    // Setup audio session for recording
    func setupAudioSession() {
        do {
            let audioSession = try AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try audioSession.setActive(true)
        } catch {
            print("Failed to set up audio session: \(error.localizedDescription)")
        }
    }
    
    // Start recording
    func startRecording() {
        // Use `withAnimation` to start the animation immediately
        withAnimation {
            isRecording = true
            recordButtonOpacity = 1.0  // Full opacity when recording
            isAnimation = true
        }
        Task {
            await speechRecognizer.startTranscribing()
        }
    }
    
    // Stop recording
    func stopRecording() {
        // Use `withAnimation` to stop the animation immediately
        withAnimation {
            isRecording = false
            recordButtonOpacity = 0.6
            isAnimation = false
        }
        
        // Save the transcription and sentiment analysis
        let newAudio = Audio(
            transcription: speechRecognizer.transcript,
            sentiment: speechRecognizer.sentiment
        )
        audioList.add_item(newAudio)
        
        // Stop transcription and recording
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
