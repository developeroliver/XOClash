//
//  RulesView.swift
//  XOClash
//
//  Created by olivier geiger on 31/05/2024.
//

import SwiftUI
import AVFoundation

struct RulesView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .center) {
                LinearGradient(
                    gradient: Gradient(colors: [.black, .green, .black, .black]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                        )
                .ignoresSafeArea()
                    .overlay(alignment: .center) {
                        Text("XO Clash")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                    }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 300)
            
            VStack(alignment: .leading) {
                Spacer()
                
                Text("Rêgles du jeu")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .padding(.horizontal)
                Divider()
                    .foregroundStyle(.primary)
                    .frame(width: 50)
                
                RuleSection(emoji: "🏆", title: "Gagnant", subTitle: "Obtenir 3 cases d'affilée. Le joueur gagne, le jeu se termine.", imageName: "win")
                
                RuleSection(emoji: "👎", title: "Défaite", subTitle: "L'adversaire en obtient 3 d'affilée. Le joueur perd, le jeu se termine.", imageName: "defeat")
                
                RuleSection(emoji: "🤝", title: "Nul", subTitle: "Plateau plein, pas de 3 à la suite. Pas de gagnant, fin de la partie.", imageName: "draw")
                
                Spacer()
            }
        }
        .background(Color(.systemGroupedBackground))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.white)
                })
            }
        }
    }
}


struct RuleSection: View {
    let emoji: String
    let title: String
    let subTitle: String
    let imageName: String
    
    @State private var isImageVisible = false
    @State private var isEmojiVisible = false
    
    var body: some View {
        HStack {
            Text(emoji)
                .font(.system(size: 30))
                .padding()
                .offset(x: isEmojiVisible ? 0 : -200, y: isEmojiVisible ? 0 : -200)
                .animation(Animation.easeInOut(duration: 1).delay(0.5))
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundStyle(.primary)
                Text(subTitle)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.primary)
            }
            Spacer()
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .opacity(isImageVisible ? 1 : 0)
                .animation(Animation.linear(duration: 1).delay(0.8))
                .padding()
        }
        .padding(.horizontal)
        .onAppear {
            isImageVisible = true
            isEmojiVisible = true
        }
    }
}

#Preview {
    RulesView()
}
