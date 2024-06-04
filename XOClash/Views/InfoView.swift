//
//  InfoView.swift
//  XOClash
//
//  Created by olivier geiger on 31/05/2024.
//

import SwiftUI

struct InfoView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isImageScaled = false
    
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
            
            VStack {
                Form {
                    Section(header: Text("À propos de l'application")) {
                        FormRowView(firstItem: "Application", secondItem: "XO Clash")
                        FormRowView(firstItem: "Platforme", secondItem: "iPhone")
                        FormRowView(firstItem: "Système", secondItem: "minimun iOS 16")
                        FormRowView(firstItem: "Développeur", secondItem: "codewitholiver")
                        FormRowView(firstItem: "Musique", secondItem: "Dan Lebowitz")
                        FormRowView(firstItem: "Site Web", displayText: "codewitholiver", url: "https://www.instagram.com/codewitholiver/")
                        FormRowView(firstItem: "Copyright", secondItem: "© All rights reserved.")
                        FormRowView(firstItem: "Version", secondItem: "1.0")
                    }
                }
                .font(.system(.body, design: .rounded))
            }
        }
        .background(Color(.systemGroupedBackground))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.easeInOut(duration: 4)) {
                    isImageScaled = true
                }
            }
        }
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

struct FormRowView: View {
    var firstItem: String
    var secondItem: String?
    var displayText: String?
    var url: String?
    
    var body: some View {
        HStack {
            Text(firstItem).foregroundColor(Color.gray)
            Spacer()
            if let displayText = displayText, let url = url, let linkURL = URL(string: url) {
                Link(displayText, destination: linkURL)
                    .foregroundColor(.blue)
            } else if let secondItem = secondItem {
                Text(secondItem)
            }
        }
    }
}

#Preview {
    NavigationStack {
        InfoView()
    }
}
