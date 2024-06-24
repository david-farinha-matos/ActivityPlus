//
//  CircleView.swift
//  ActivityPlus
//
//  Created by David Matos on 19/06/2024.
//

import Foundation
import SwiftUI

struct CircleView: View {

    private let shadowRadius: CGFloat = 10
    private let shadowColor: Color = .foregroundGray

    var body: some View {
        Circle().fill(Color.white)
            .shadow(color: shadowColor, radius: shadowRadius)
    }
}

