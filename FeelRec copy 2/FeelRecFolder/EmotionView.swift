//
//  EmotionalView.swift
//  ProjectML
//
//  Created by Giovanni Jr Di Fenza on 10/12/24.
//

import SwiftUI

struct EmotionView: View {
    @ObservedObject var sleepModel: SleepModel
    @State private var week = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    @State private var currentTime = Date()
    @State private var infoBreath = false
    @State private var infoHeart = false
    @State var percentage1: Double = 0
    @State var percentage2: Double = 0
    
    func getcurrentTime() -> String {
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
    
    init(sleepModel: SleepModel) {
        self.sleepModel = sleepModel
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.color]
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Color 1")
                    .ignoresSafeArea()
                
                VStack {
                    Text(getcurrentTime())
                        .font(.title3)
                        .foregroundColor(Color.color)
                        .padding(.trailing, 200)
                    
                    HStack {
                        // Respiratory Card
                        ZStack {
                            RoundedRectangle(cornerRadius: 13)
                                .frame(width: 150, height: 200)
                                .foregroundStyle(Color("Color"))
                            
                            // Card Content
                            VStack {
                                HStack {
                                    Text("Respiratory")
                                        .font(.headline)
                                        .foregroundColor(.black)
                                    Button(action: {
                                        infoBreath.toggle()
                                    }) {
                                        Image(systemName: "info.circle")
                                            .font(.system(size: 20))
                                            .foregroundColor(.black)
                                    }
                                    .popover(isPresented: $infoBreath) {
                                        InfoBreathView(infoBreath: $infoBreath)
                                    }
                                }
                                .offset(y: -10)
                                
                                Divider()
                                    .frame(width: 150)
                                    .background(Color.gray)
                                    .offset(y: -10)
                                
                                // Rings
                                ZStack {
                                    Ring(lineWidth: 20,
                                         backgroundColor: Color.blue.opacity(0.3),
                                         foregroundColor: Color.blue,
                                         percentage: percentage1)
                                    .frame(width: 120, height: 120)
                                    Ring(lineWidth: 20,
                                         backgroundColor: Color.green.opacity(0.3),
                                         foregroundColor: Color.green,
                                         percentage: percentage1)
                                    .frame(width: 80, height: 80)
                                }
                                .padding(.top, 5)
                                .offset(y: -10)
                            }
                            .padding(.top, 20)
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Heart Card
                        ZStack {
                            RoundedRectangle(cornerRadius: 13)
                                .frame(width: 150, height: 200)
                                .foregroundStyle(Color("Color"))
                            
                            // Card Content
                            VStack {
                                HStack {
                                    Text("Heart")
                                        .font(.headline)
                                        .foregroundColor(.black)
                                        .padding(.trailing, 45)
                                    Button(action: {
                                        infoHeart.toggle()
                                    }) {
                                        Image(systemName: "info.circle")
                                            .font(.system(size: 20))
                                            .foregroundColor(.black)
                                    }
                                    .popover(isPresented: $infoHeart) {
                                        InfoHeartView(infoHeart: $infoHeart)
                                    }
                                }
                                .offset(y: -10)
                                
                                Divider()
                                    .frame(width: 150)
                                    .background(Color.gray)
                                    .offset(y: -10)
                                
                                // Rings
                                ZStack {
                                    Ring(lineWidth: 20,
                                         backgroundColor: Color.red.opacity(0.3),
                                         foregroundColor: Color.red,
                                         percentage: percentage2)
                                    .frame(width: 120, height: 120)
                                    Ring(lineWidth: 20,
                                         backgroundColor: Color.yellow.opacity(0.3),
                                         foregroundColor: Color.yellow,
                                         percentage: percentage1)
                                    .frame(width: 80, height: 80)
                                }
                                .padding(.top, 10)
                                .offset(y: -10)
                            }
                            .padding(.top, 20)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding()
                    
                    SleepGraph(week: $week, currentTime: $currentTime, sleepModel: sleepModel)
                    Spacer()
                }
            }
            .navigationTitle("Parameters")
        }
    }
}
struct EmotionView_Previews: PreviewProvider {
    static var previews: some View {
        EmotionView(sleepModel: SleepModel())
            .onAppear {
                UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.color]
            }
    }
}

// End of file. No additional code.
