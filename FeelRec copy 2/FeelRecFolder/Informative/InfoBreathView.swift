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
            ZStack {
                Color("Color")
                    .ignoresSafeArea()
                Form {
                    Section(header:
                                HStack {
                        Text("About Respiratory Rate")
                            .font(.system(size: 20))
                            .bold()
                            .foregroundColor(Color("Color 1"))
                        Image(systemName: "lungs.fill")
                            .font(.system(size: 20))
                            .foregroundColor(Color("Color 1"))  // Use your asset color name here
                    }
                    ){
                        // Rest of the section content remains the same
                        Text("Respiratory rate is the number of breaths per minute. It measures how many cycles of inhalation and exhalation a person completes in one minute.\n\nRespiratory rate is an important indicator of respiratory health and overall well-being. A normal respiratory rate for a healthy adult is typically between 12 and 20 breaths per minute. \n\nChanges in this rate can indicate various health conditions, such as respiratory illnesses, fever, or cardiovascular issues.")
                            .foregroundColor(.black)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationBarItems(
                trailing: Button("Done") {
                    infoBreath = false
                } .foregroundStyle(Color("Color 1"))
            )
        }
    }
}
struct InfoBreathView_Previews: PreviewProvider {
    static var previews: some View {
        InfoBreathView(infoBreath: .constant(true))
            .onAppear {
                UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.color]
            }
    }
}
