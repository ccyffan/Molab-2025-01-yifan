import SwiftUI
import AVFoundation

struct PlaybackView: View {
    let selectedNoise: String  // 传入的音频文件名
    let duration: Int
    @ObservedObject var audioManager: AudioManager
    @State private var isPlaying = true // 记录播放状态
    @State private var remainingTime: Int // 倒计时
    @Environment(\.presentationMode) var presentationMode  // 监听返回

    init(selectedNoise: String, duration: Int, audioManager: AudioManager) {
        self.selectedNoise = selectedNoise
        self.duration = duration
        self.audioManager = audioManager
        _remainingTime = State(initialValue: duration * 60)  // 将分钟转换为秒
    }

    var body: some View {
        VStack {
            Text("Playing: \(selectedNoise)")
                .font(.custom("Courier", size: 24))
                .padding()

            // 显示倒计时
            Text("\(remainingTime / 60) min \(remainingTime % 60) sec")
                .font(.custom("Courier", size: 20))
                .padding()
                .onAppear {
                    startTimer()
                }

            Button(action: {
                if isPlaying {
                    audioManager.pauseAudio()
                } else {
                    audioManager.playAudio(named: selectedNoise)
                }
                isPlaying.toggle()
            }) {
                Text(isPlaying ? "Pause" : "Resume")
                    .font(.custom("Courier", size: 20))
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            Button(action: {
                audioManager.stopAudio()  // 停止播放
                presentationMode.wrappedValue.dismiss()  // 退出页面
            }) {
                Text("Back")
                    .font(.custom("Courier", size: 20))
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .onAppear {
            audioManager.playAudio(named: selectedNoise)  // 页面打开时播放
        }
        .onDisappear {
            audioManager.stopAudio()  // 页面关闭时停止播放
        }
    }

    // **✅ 添加倒计时逻辑**
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                timer.invalidate()
                audioManager.stopAudio()  // 倒计时结束时停止音频
            }
        }
    }
}

#Preview {
    PlaybackView(selectedNoise: "fireplace", duration: 30, audioManager: AudioManager())
}
