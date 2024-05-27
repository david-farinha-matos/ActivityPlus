//
//  SettingsRowView.swift
//  ActivityPlus
//
//  Created by David Matos on 27/05/2024.
//

import Foundation
import SwiftUI

struct SettingRowView: View {
    let imageName: String
    let title: String
    let tintColour: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: imageName)
                .imageScale(.small)
                .font(.title)
                .foregroundColor(tintColour)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.black)
        }
    }
}

#Preview {
    SettingRowView(imageName: "gear", title: "Version", tintColour: Color(.systemGray))
}
