import SwiftUI

struct NoiseSelectionView: View {
    @State private var selectedIndex = 0
    @State private var selectedDuration = 30
    @State private var isNavigating = false  // 控制页面跳转
    @ObservedObject var audioManager = AudioManager()
    
    let noises = [
        ("fireplace", "fireplace"),
        ("forest", "forest"),
        ("rain", "rain"),
        ("river", "river"),
        ("storm", "storm")
    ]

    
    let durations = [30, 60, 120, 180]
    
    var body: some View {
        NavigationStack {  // 让 NavigationLink 可以跳转
            VStack {
                Text("Select White Noise")
                    .font(.custom("Courier", size: 24)) // 打字机字体
                    .padding()
                
                HStack {
                    // 左侧选择按钮
                    Button(action: {
                        selectedIndex = (selectedIndex - 1 + noises.count) % noises.count
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.largeTitle)
                            .padding()
                    }
                    
                    // 中间显示当前选择
                    VStack {
                        Image(noises[selectedIndex].0)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: .infinity) // 适当放大图片
                            .padding()
                        
                        Text(noises[selectedIndex].0.capitalized)
                            .font(.custom("Courier", size: 20))
                            .padding()
                    }
                    
                    // 右侧选择按钮
                    Button(action: {
                        selectedIndex = (selectedIndex + 1) % noises.count
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.largeTitle)
                            .padding()
                    }
                }
                
                // 选择播放时长
                HStack {
                    ForEach(durations, id: \.self) { duration in
                        Button(action: {
                            selectedDuration = duration
                        }) {
                            Text("\(duration) min")
                                .padding()
                                .background(selectedDuration == duration ? Color.gray : Color.clear)
                                .cornerRadius(10)
                        }
                    }
                }
                
                // 开始播放按钮
                NavigationLink(destination: PlaybackView(selectedNoise: noises[selectedIndex].1, duration: selectedDuration, audioManager: audioManager), isActive: $isNavigating) {
                    EmptyView()
                }
                .hidden()
                
                Button(action: {
                    isNavigating = true  // 触发跳转
                }) {
                    Text("Start Playing")
                        .font(.custom("Courier", size: 20))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .padding()
        }
    }
}

#Preview {
    NoiseSelectionView()
}
