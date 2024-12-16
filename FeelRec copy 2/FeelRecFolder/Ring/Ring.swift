//
//  Ring.swift
//  ProjectML
//
//  Created by Giovanni Jr Di Fenza on 10/12/24.
//

import SwiftUI

struct Ring: View {
    let lineWidth: CGFloat
    let backgroundColor: Color
    let foregroundColor: Color
    let percentage: Double
    
    // Add states for animation control
    @State private var animatedPercentage: Double = 0
    @State private var isLoading: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background circle remains the same
                RingShape(percent: 100, startAngle: -90)
                    .stroke(style: StrokeStyle(lineWidth: lineWidth))
                    .fill(backgroundColor)
                
                // Animated foreground
                RingShape(percent: animatedPercentage, startAngle: -90)
                    .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                    .fill(foregroundColor)
                    .animation(.easeInOut(duration: 2), value: animatedPercentage)
            }
            .padding(lineWidth / 2)
            .onTapGesture {
                // Start loading animation
                if !isLoading {
                    isLoading = true
                    animatedPercentage = 100
                }
            }
            .onAppear {
                // Set initial percentage
                animatedPercentage = percentage
            }
        }
    }
}
