import AVFoundation

class AudioManager: ObservableObject {
    var audioPlayer: AVAudioPlayer?

    func playAudio(named soundName: String) {
        guard let soundURL = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
            print("⚠️ Audio file not found: \(soundName).mp3")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.numberOfLoops = -1  // 无限循环播放
            audioPlayer?.play()
            print("🎵 Playing: \(soundName).mp3")
        } catch {
            print("❌ Error playing audio: \(error.localizedDescription)")
        }
    }

    func pauseAudio() {
        audioPlayer?.pause()
        print("⏸ Audio Paused")
    }

    func stopAudio() {
        audioPlayer?.stop()
        audioPlayer = nil
        print("⏹ Audio Stopped")
    }
}
