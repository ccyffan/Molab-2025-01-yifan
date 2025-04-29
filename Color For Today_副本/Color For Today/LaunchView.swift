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
                // 3 秒后自动切换到主界面
                ContentView()
            } else {
                // 闪屏界面
                ZStack {
                    // 动画渐变背景
                    LinearGradient(
                        gradient: Gradient(colors: [.purple, .pink, .orange, .yellow]),
                        startPoint: animateGradient ? .topLeading : .bottomTrailing,
                        endPoint: animateGradient ? .bottomTrailing : .topLeading
                    )
                    .ignoresSafeArea()
                    .animation(.linear(duration: 4).repeatForever(autoreverses: true), value: animateGradient)

                    // App 名称
                    Text("Color For Today")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                }
                .onAppear {
                    // 启动动画
                    animateGradient = true
                    // 3 秒后切换
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
#Preview {
    LaunchView()
}
