//
//  SpeechRecognizer.swift
//  ProjectML
//
//  Created by Giovanni Jr Di Fenza on 05/12/24.
//

import AVFoundation
import Foundation
import NaturalLanguage
import Speech
import SwiftUI

/// A helper for transcribing speech to text using SFSpeechRecognizer and AVAudioEngine.
actor SpeechRecognizer: ObservableObject {
    enum RecognizerError: Error {
        case nilRecognizer
        case notAuthorizedToRecognize
        case notPermittedToRecord
        case recognizerIsUnavailable
        
        var message: String {
            switch self {
            case .nilRecognizer: return "Can't initialize speech recognizer"
            case .notAuthorizedToRecognize: return "Not authorized to recognize speech"
            case .notPermittedToRecord: return "Not permitted to record audio"
            case .recognizerIsUnavailable: return "Recognizer is unavailable"
            }
        }
    }
    
    @MainActor var transcript: String = ""
    @MainActor var sentiment: String = "" 

    private var audioEngine: AVAudioEngine?
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private let recognizer: SFSpeechRecognizer?

    /**
     Initializes a new speech recognizer. If this is the first time you've used the class, it
     requests access to the speech recognizer and the microphone.
     */
    init() {
        recognizer = SFSpeechRecognizer()
        guard recognizer != nil else {
            transcribe(RecognizerError.nilRecognizer)
            return
        }
        
        // Verifica i permessi
        Task {
            do {
                // Controlla se l'app è autorizzata a utilizzare il riconoscimento vocale
                let authorized = await requestSpeechRecognitionAuthorization()
                guard authorized else {
                    throw RecognizerError.notAuthorizedToRecognize
                }
                
                // Controlla se l'app ha il permesso di registrare audio
                let audioPermission = await requestAudioRecordingPermission()
                guard audioPermission else {
                    throw RecognizerError.notPermittedToRecord
                }
            } catch {
                transcribe(error)
            }
        }
    }

    // Funzione per richiedere l'autorizzazione al riconoscimento vocale
    private func requestSpeechRecognitionAuthorization() async -> Bool {
        await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                switch status {
                case .authorized:
                    continuation.resume(returning: true)
                case .denied, .restricted, .notDetermined:
                    continuation.resume(returning: false)
                @unknown default:
                    continuation.resume(returning: false)
                }
            }
        }
    }

    // Funzione per richiedere l'autorizzazione alla registrazione audio
    private func requestAudioRecordingPermission() async -> Bool {
        await withCheckedContinuation { continuation in
            AVAudioSession.sharedInstance().requestRecordPermission { authorized in
                continuation.resume(returning: authorized)
            }
        }
    }

    // Start transcribing
    @MainActor func startTranscribing() {
        Task {
            await transcribe()
        }
    }

    // Stop transcribing
    @MainActor func stopTranscribing() {
        Task {
            await reset()
        }
    }

    /**
     Begin transcribing audio.
     
     Creates a `SFSpeechRecognitionTask` that transcribes speech to text until you call `stopTranscribing()`.
     The resulting transcription is continuously written to the published `transcript` property.
     */
    private func transcribe() {
        guard let recognizer, recognizer.isAvailable else {
            self.transcribe(RecognizerError.recognizerIsUnavailable)
            return
        }
        
        do {
            let (audioEngine, request) = try Self.prepareEngine()
            self.audioEngine = audioEngine
            self.request = request
            self.task = recognizer.recognitionTask(with: request, resultHandler: { [weak self] result, error in
                self?.recognitionHandler(audioEngine: audioEngine, result: result, error: error)
            })
        } catch {
            self.reset()
            self.transcribe(error)
        }
    }

    /// Reset the speech recognizer.
    private func reset() {
        task?.cancel()
        audioEngine?.stop()
        audioEngine = nil
        request = nil
        task = nil
    }

    private static func prepareEngine() throws -> (AVAudioEngine, SFSpeechAudioBufferRecognitionRequest) {
        let audioEngine = AVAudioEngine()
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true

        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.playAndRecord, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)

        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            request.append(buffer)
        }

        audioEngine.prepare()
        try audioEngine.start()

        return (audioEngine, request)
    }

    nonisolated private func recognitionHandler(audioEngine: AVAudioEngine, result: SFSpeechRecognitionResult?, error: Error?) {
        let receivedFinalResult = result?.isFinal ?? false
        let receivedError = error != nil

        if receivedFinalResult || receivedError {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }

        if let result {
            transcribe(result.bestTranscription.formattedString)
        }
    }

    // Transcribe the recognized speech and perform sentiment analysis
    nonisolated private func transcribe(_ message: String) {
        Task { @MainActor in
            transcript = message
            sentiment = await analyzeSentiment(for: message)
        }
    }

    nonisolated private func transcribe(_ error: Error) {
        var errorMessage = ""
        if let error = error as? RecognizerError {
            errorMessage += error.message
        } else {
            errorMessage += error.localizedDescription
        }

        Task { @MainActor [errorMessage] in
            transcript = "<< \(errorMessage) >>"
        }
    }
    // Perform sentiment analysis on the transcribed text
    func analyzeSentiment(for stringToAnalyze: String) -> String {
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = stringToAnalyze
        let (sentimentScore, _) = tagger.tag(at: stringToAnalyze.startIndex, unit: .paragraph, scheme: .sentimentScore)
        let score = Double(sentimentScore?.rawValue ?? "0") ?? 0.0
        
        if score > 0.5 {
            return "😊"
        } else if score <= 0.5 && score >= -0.5 {
            return "😐"
        } else {
            return "☹️"
        }
    }
}


