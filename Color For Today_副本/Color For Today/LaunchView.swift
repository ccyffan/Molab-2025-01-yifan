//
//  LaunchView.swift
//  Color For Today
//
//  Created by 陈艺凡 on 4/28/25.
//

import SwiftUI

struct LaunchView: View {
    @State private var isActive = false
    @State private var animateGradient = false

    var body: some View {
        Group {
            if isActive {
                ContentView()
            } else {
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [.pink, .blue, .orange ]),
                        startPoint: animateGradient ? .topLeading : .bottomTrailing,
                        endPoint: animateGradient ? .bottomTrailing : .topLeading
                    )
                    .ignoresSafeArea()
                    .animation(.linear(duration: 4).repeatForever(autoreverses: true), value: animateGradient)

                 
                    Text("COLOR FOR TODAY")
                        .font(.title3)
                        .fontWeight(.bold)
                        .kerning(5)
                        .foregroundColor(.white.opacity(0.7))

                }
                .onAppear {
                    animateGradient = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            isActive = true
                        }
                    }
                }
            }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}

#Preview {
    LaunchView()
}
