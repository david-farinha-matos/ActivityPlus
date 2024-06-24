//
//  DialView.swift
//  ActivityPlus
//
//  Created by David Matos on 19/06/2024.
//

import Foundation
import SwiftUI

struct DialView: View {

    let goal: Int
    let steps: Int

    var body: some View {
        ZStack {

            ZStack {
                CircleView()
                
                // Circle which progress bar goes over
                Circle().stroke(style: StrokeStyle(lineWidth: 12))
                    .padding(20)
                    .foregroundColor(Color(red: 0.850, green: 0.875, blue: 1))

                // circle for the progess bar
                Circle()
                    .trim(from: 0, to: (CGFloat(steps) / CGFloat(goal)))
                    .scale(x: -1)
                    .rotation(.degrees(90))
                    .stroke(style: StrokeStyle(lineWidth: 12, lineCap: .butt))
                    .padding(20)
                    .foregroundColor(Color(red: 0.275, green: 0.235, blue: 1))

                VStack {
                    Text("Goal: \(goal)")
                    Text("\(steps)")
                        .font(.title)
                        .bold()
                        .padding()
                    Text("Steps")
                }
            }
            .padding()
        }
        .foregroundColor(.accentColor)
        
    }

}
