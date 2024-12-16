//
//  InformationView.swift
//  ProjectML
//
//  Created by Giovanni Jr Di Fenza on 13/12/24.
//

import SwiftUI

struct InfoBreathView: View {
    @Binding var infoBreath: Bool
    var body: some View {
        NavigationStack {
            Form {
                Section(header:
                    HStack {
                    Text("About Respiratory Rate")
                        .font(.system(size: 20))
                        .bold()
                    Image(systemName: "lungs.fill")
                        .font(.system(size: 20))
                        .foregroundColor(Color(red: 0.4, green: 0.8, blue: 1.0))
                }
            ){
                        Text("Respiratory rate is the number of breaths per minute. It measures how many cycles of inhalation and exhalation a person completes in one minute.\n\nRespiratory rate is an important indicator of respiratory health and overall well-being. A normal respiratory rate for a healthy adult is typically between 12 and 20 breaths per minute. \n\nChanges in this rate can indicate various health conditions, such as respiratory illnesses, fever, or cardiovascular issues.")
                }
            }
            .navigationBarItems(
                trailing: Button("Done") {
                    infoBreath = false
                }
            )
        }
    }
}

#Preview {
    InfoBreathView(infoBreath: .constant(true))
}
