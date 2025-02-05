//
//  InformationView.swift
//  FeelRec2
//
//  Created by Giovanni Jr Di Fenza on 30/01/25.
//

import SwiftUI

struct InformationView: View {
    
    @AppStorage("hasSeenInformation") private var hasSeenInformation: Bool = false
    @Environment(\.dismiss) private var dismiss
    @State private var isStartPressed: Bool = false
    
    @State private var isStartPresseded: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.accentColor
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    List {
                        Section(header: Text("How to use FeelRec")
                            .font(.system(size: 24))
                            .foregroundColor(Color.black)
                            .opacity(0.8)) {
                                Text("FeelRec is a voice recording and sentiment analysis app.\nTo start, tap the record button at the bottom of the screen to begin recording.\nWhen you're finished, tap the same button again to stop the recording. Your recordings will be saved and organized by the date they were made.\nIf you ever want to read the instructions again, tap the icon in the top-left corner. This will allow you to access the information and review it whenever you'd like.\nWhenever you're ready to record again, simply tap the record button at the bottom of the screen.\nThe app will analyze the sentiment of each recording and store it for you to reference later.\nSound or haptic feedback will confirm your actions, so you know exactly what's happening.")
                                    .font(.system(size: 19))
                            }
                    }
                    .scrollContentBackground(.hidden)
                    .listRowBackground(Color.accentColor)
                    
                    NavigationLink {
                        ContentView()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        Text("Start")
                            .font(.title)
                            .frame(width: 300, height: 70)
                            .background(Color.black)
                            .opacity(0.8)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 20)
                    .simultaneousGesture(TapGesture().onEnded {
                        isStartPressed = true
                        hasSeenInformation = true
                    })
                    .sensoryFeedback(.success, trigger: isStartPressed)
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}
#Preview {
    InformationView()
}

