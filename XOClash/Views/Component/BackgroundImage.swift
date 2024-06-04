//
//  BackgroundImage.swift
//  XOClash
//
//  Created by olivier geiger on 31/05/2024.
//

import SwiftUI

struct BackgroundImage: View {
    var body: some View {
        Image("background5")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
}

#Preview {
    BackgroundImage()
}
