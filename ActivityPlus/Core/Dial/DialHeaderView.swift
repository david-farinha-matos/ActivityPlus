//
//  DialHeaderView.swift
//  ActivityPlus
//
//  Created by David Matos on 20/06/2024.
//

import Foundation
import SwiftUI

struct DialHeaderView: View {

    let name: String
    let image: String

    var body: some View {
        HStack {
            Image("DavidPicture")
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: 100, height: 100)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Good Morning\n\(name)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.top, 4)
                }
                
                Text("Let's get started")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .foregroundColor(.accentColor)
        }
    }

}
