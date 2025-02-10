//
//  OnboardingView.swift
//  FeelRec2
//
//  Created by Giovanni Jr Di Fenza on 07/02/25.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasSeenInformation") private var hasSeenInformation: Bool = false
    @Environment(\.dismiss) private var dismiss
    @State private var isStartPressed: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.accentColor
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Welcome to FeelRec")
                        .font(.system(size: 35, weight: .bold, design: .default))
                        .foregroundColor(.black)
                        .opacity(0.8)
                        .padding()
                    Spacer()
                    HStack {
                        Image("Touch")
                            .opacity(0.8)
                        VStack(alignment: .leading) {
                            Text("Record your speech")
                                .bold()
                                .font(.system(size: 24))
                                .padding()
                            Text("Tap the button to start and stop recording.")
                                .font(.system(size: 20))
                                .opacity(0.8)
                        }
                    }
                    .padding(.horizontal)
                    Spacer().frame(height: 50)
                    HStack {
                        Image("Sentiment")
                            .opacity(0.8)
                        VStack(alignment: .leading) {
                            Text("Sentiment analysis")
                                .bold()
                                .font(.system(size: 24))
                                .padding()
                            Text("Make the sentiment analysis of your speech.")
                                .font(.system(size: 20))
                                .opacity(0.8)
                        }
                    }
                    .padding(.horizontal)
                    Spacer()
                    
                    NavigationLink(destination: ContentView())
                    {
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
    OnboardingView()
}
