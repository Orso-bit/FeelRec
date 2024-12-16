//
//  InfoHeartView.swift
//  ProjectML
//
//  Created by Giovanni Jr Di Fenza on 13/12/24.
//

import SwiftUI

struct InfoHeartView: View {
    @Binding var infoHeart: Bool
    var body: some View {
        NavigationStack {
            Form {
                Section(header:
                            HStack {
                    Text("About Heart Rate")
                        .font(.system(size: 20))
                        .bold()
                    Image(systemName: "heart.fill")
                        .font(.system(size: 20))
                        .foregroundColor(Color.red)
                }
                ){
                    Text("Heart rate refers to the number of times the heart beats per minute (bpm). It is a key indicator of heart function and overall cardiovascular health.\n\nA normal resting heart rate for adults typically ranges from 60 to 100 beats per minute, though it can vary based on factors like age, fitness level, and activity level.\n\nThe heart rate increases with physical exertion, stress, and excitement, and it decreases during periods of rest or sleep.")
                }
            }
            .navigationBarItems(
                trailing: Button("Done") {
                    infoHeart = false
                }
            )
        }
    }
}
