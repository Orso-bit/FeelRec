//
//  EmptyStateView.swift
//  FeelRec2
//
//  Created by Giovanni Jr Di Fenza on 01/02/25.
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "archivebox")
                .resizable()
                .foregroundStyle(Color.black)
                .opacity(0.8)
                .frame(width: 70, height: 65)
                .padding()
                .accessibilityLabel("No recordings icon")
                .accessibilityHint("Indicates that no recordings are available.")
            
            Text("No Recordings")
                .foregroundStyle(Color.black)
                .opacity(0.8)
                .font(.title)
                .bold()
                .accessibilityLabel("No recordings available")
                .accessibilityHint("Displays when no recordings have been made.")
                .accessibilityValue("No recordings available")
            
            Text("Tap the Record button to reveal what you feel\nThey will be inserted in a list")
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.black)
                .opacity(0.8)
                .font(.system(size: 18))
                .fontWeight(.regular)
                .accessibilityLabel("Instruction to start recording")
                .accessibilityHint("Tells the user to tap the Record button in the bottom center to begin recording.")
            Spacer()
        }
    }
}

#Preview {
    EmptyStateView()
}
