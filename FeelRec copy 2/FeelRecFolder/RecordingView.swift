//
//  RecordingView.swift
//  FeelRec2
//
//  Created by Giovanni Jr Di Fenza on 01/02/25.
//

import SwiftUI

struct RecordingView: View {
    @Binding var isRecording: Bool
    var startRecording: () -> Void
    var stopRecording: () -> Void
    
    var body: some View {
        VStack {
            // Audio Waves
            HStack {
                ForEach(0..<38) { item in
                    RoundedRectangle(cornerRadius: 2)
                        .frame(width: 2, height: .random(in: 20...45))
                        .foregroundStyle(Color.black)
                        .opacity(0.8)
                        .animation(
                            isRecording ?
                                .easeInOut(duration: 0.4)
                                .repeatForever(autoreverses: true) :
                                    .default,
                            value: isRecording
                        )
                }
            }
            .padding(.bottom, 20)
            
            // Record button
            Button(action: {
                if isRecording {
                    stopRecording()
                } else {
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
            .accessibilityLabel(isRecording ? "Stop recording" : "Start recording")
            /*.accessibilityValue(isRecording ? "Recording in progress" : "Not recording")*/
            /*.accessibilityHint(isRecording ? "Double tap to stop recording" : "Double tap to start recording")*/
            .accessibilityAddTraits(.isButton)
        }
    }
}
