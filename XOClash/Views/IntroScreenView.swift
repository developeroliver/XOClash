//
//  IntroScreenView.swift
//  XOClash
//
//  Created by olivier geiger on 01/06/2024.
//

import SwiftUI

struct IntroScreenView: View {
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    
    var body: some View {
        VStack(spacing: 15) {
            VStack {
                Text("XO Clash")
                Text("-")
                Text("Le Morpion Intemporel !")
                    
            }
            .font(.largeTitle.bold())
            .multilineTextAlignment(.center)
            .padding(.top, 65)
            .padding(.bottom, 35)
            
            VStack(alignment: .leading, spacing: 15) {
                PointView(symbol: "gamecontroller", title: "Lancez une Partie!", subTitle: "Prenez une pause et amusez-vous avec une partie de morpion.")
                
                PointView(symbol: "person.2.fill", title: "Invitez un Ami !", subTitle: "Invitez un ami! Que ce soit pour un moment de détente ou un défi compétitif.")
                
                PointView(symbol: "macpro.gen3", title: "Défiez Notre Bot!", subTitle: "Découvrez une nouvelle façon de jouer en faisant une partie avec notre bot intelligent.")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 15)
            Spacer()
            Button(action: {
                isFirstTime = false
            }, label: {
                Text("Continue")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color(.black))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            })
        }
        .padding(15)
        .background(Color(.systemGroupedBackground))
    }
    
    @ViewBuilder
    func PointView(symbol: String, title: String, subTitle: String) -> some View {
        HStack(spacing: 20) {
            Image(systemName: symbol)
                .font(.largeTitle)
                .foregroundStyle(.primary)
                .frame(width: 45)
            
            VStack(alignment: .leading, spacing: 6, content: {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(subTitle)
                    .font(.callout)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.leading)
            })
        }
    }
}

#Preview {
    IntroScreenView()
}
