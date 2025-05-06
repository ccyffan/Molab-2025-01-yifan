import SwiftUI
import LunarSwift

struct ContentView: View {
    @State private var selectedDate = Date()
    @State private var dateString = ""
    @State private var lunarDateString = ""
    @State private var dayElement = ""
    @State private var generatedElement = ""
    @State private var luckyColor = ""
    @State private var showingInfo = false
    @State private var showDatePicker = false
    
    // Animation states
    @State private var animationAmount = 0.0
    @State private var isAnimating = true

    @State private var allElementColors: [(element: String, colors: [String])] = []
    @State private var selectedElementColors: [String] = []

    private let lunarHelper = LunarCalendarHelper()

    var body: some View {
        ZStack {
            // 元素主题色彩背景 - 使用该元素的三种颜色渐变
            elementColorBackground
                .ignoresSafeArea()
            
            // 精美的背景元素图形 - 添加轻微动画
            elementBackgroundDecoration
                .opacity(0.25)
                .ignoresSafeArea()
            
            // 主内容
            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    // 顶部日期显示
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            // 农历日期
                            Text(lunarDateString)
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.8))
                                .padding(.vertical, 2)
                                .padding(.horizontal, 10)
                                .background(
                                    Capsule()
                                        .fill(Color.black.opacity(0.2))
                                )
                            
                            // 公历日期 - 日
                            Text(formattedDay())
                                .font(.system(size: 72, weight: .bold))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                            
                            // 公历月份和年份
                            Text(formattedDate())
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        
                        Spacer()
                        
                        // 日期选择器按钮
                        Button(action: { showDatePicker.toggle() }) {
                            Image(systemName: "calendar")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding(12)
                                .background(
                                    Circle()
                                        .fill(Color.white.opacity(0.15))
                                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                                )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 30)
                    
                    // 日期选择器（条件显示）
                    if showDatePicker {
                        DatePicker("", selection: $selectedDate, displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white.opacity(0.15))
                                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                            )
                            .padding(.horizontal)
                            .onChange(of: selectedDate) { _ in
                                updateLuckyColor()
                                showDatePicker = false
                            }
                    }
                    
                    // 幸运色显示
                    VStack(spacing: 15) {
                        // 标签
                        Text("TODAY'S COLOR")
                            .font(.caption)
                            .fontWeight(.bold)
                            .kerning(2)
                            .foregroundColor(.white.opacity(0.7))
                        
                        HStack(alignment: .center, spacing: 20) {
                            // 左侧颜色名称
                            Text(luckyColor)
                                .font(.system(size: 56, weight: .bold))
                                .minimumScaleFactor(0.5)
                                .lineLimit(1)
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
                                .frame(width: 160, alignment: .trailing)
                            
                            // 右侧颜色圆形
                            Circle()
                                .fill(getSwiftUIColor(for: luckyColor))
                                .frame(width: 140, height: 140)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 2)
                                        .opacity(0.3)
                                )
                                .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 5)
                        }
                        .padding(.vertical, 20)
                        .padding(.horizontal)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.black.opacity(0.1))
                        )
                        .padding(.horizontal, 20)
                    }
                    .padding(.vertical, 30)
                    
                    // 五行颜色选项
                    VStack(alignment: .leading, spacing: 20) {
                        Text("COLOR OPTIONS")
                            .font(.caption)
                            .fontWeight(.bold)
                            .kerning(2)
                            .foregroundColor(.white.opacity(0.7))
                            .padding(.leading, 20)
                        
                        // 所有选项水平滚动
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                // 推荐颜色组
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(generatedElement)
                                        .font(.caption2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(
                                            Capsule()
                                                .fill(Color.white.opacity(0.2))
                                        )
                                    
                                    HStack(spacing: 12) {
                                        ForEach(selectedElementColors, id: \.self) { color in
                                            ColorOptionEnhanced(
                                                color: color,
                                                isSelected: color == luckyColor,
                                                onTap: {
                                                    // 添加点击事件修改幸运色
                                                    luckyColor = color
                                                }
                                            )
                                        }
                                    }
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal, 15)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.white.opacity(0.1))
                                )
                                
                                // 其他元素颜色
                                ForEach(allElementColors.filter { $0.element != generatedElement }, id: \.element) { info in
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(info.element)
                                            .font(.caption2)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white.opacity(0.7))
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(
                                                Capsule()
                                                    .fill(Color.white.opacity(0.1))
                                            )
                                        
                                        HStack(spacing: 12) {
                                            ForEach(info.colors, id: \.self) { color in
                                                ColorOptionEnhanced(
                                                    color: color,
                                                    isSelected: color == luckyColor,
                                                    onTap: {
                                                        // 添加点击事件修改幸运色
                                                        luckyColor = color
                                                    }
                                                )
                                            }
                                        }
                                    }
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 15)
                                    .background(
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(Color.white.opacity(0.05))
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.top, 10)
                    
                    Spacer(minLength: 60)
                    
                    // 底部操作栏
                    HStack(spacing: 15) {
                        Button {
                            selectedDate = Date()
                            updateLuckyColor()
                        } label: {
                            HStack {
                                Image(systemName: "arrow.clockwise")
                                Text("Today")
                            }
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.white.opacity(0.15))
                                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                            )
                        }
                        
                        Button {
                            showingInfo = true
                        } label: {
                            Image(systemName: "info.circle")
                                .font(.title3)
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                                .background(
                                    Circle()
                                        .fill(Color.white.opacity(0.15))
                                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                                )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
        }
        .onAppear {
            updateLuckyColor()
            // 启动动画循环
            startAnimation()
        }
        .sheet(isPresented: $showingInfo) {
            FiveElementsInfoView()
        }
    }
    
    // 启动动画
    private func startAnimation() {
        withAnimation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
            animationAmount = 5
        }
    }
    
    // 元素对应的颜色渐变背景
    private var elementColorBackground: some View {
        let colors = getElementGradientColors(for: generatedElement)
        
        return LinearGradient(
            gradient: Gradient(colors: colors),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // 获取元素对应的三种颜色用于渐变
    private func getElementGradientColors(for element: String) -> [Color] {
        let colorsForElement = getModifiedColorsForElement(element)
        return colorsForElement.map { getSwiftUIColor(for: $0).opacity(0.85) }
    }
    
    // 精美的元素背景装饰
    private var elementBackgroundDecoration: some View {
        ZStack {
            Group {
                switch generatedElement {
                case "Wood":
                    // 树叶/木元素图形 - 更自然的非对称版本
                    ForEach(0..<5) { i in
                        NaturalLeafShape(seed: CGFloat(i))
                            .fill(getSwiftUIColor(for: selectedElementColors[i % selectedElementColors.count]))
                            .frame(width: CGFloat(80 + i * 20), height: CGFloat(120 + i * 30))
                            .rotationEffect(Angle(degrees: Double(i * 72 + Int.random(in: -5...5))))
                            .offset(x: CGFloat(sin(Double(i)) * 120),
                                    y: CGFloat(cos(Double(i)) * 120) - 200)
                            .modifier(SwayingModifier(
                                angle: animationAmount * Double(i % 3 + 1) * 0.6,
                                scale: 1.0 + sin(animationAmount * 0.3 + Double(i)) * 0.03
                            ))
                    }
                    
                case "Fire":
                    // 火焰图形 - 更自然的非对称版本
                    ZStack {
                        ForEach(0..<5) { i in
                            NaturalFlameShape(seed: CGFloat(i))
                                .fill(getSwiftUIColor(for: selectedElementColors[i % selectedElementColors.count]))
                                .frame(width: CGFloat(50 + i * 15), height: CGFloat(100 + i * 25))
                                .offset(x: CGFloat(sin(Double(i)) * 100),
                                        y: CGFloat(cos(Double(i)) * 80) - 150)
                                .rotationEffect(Angle(degrees: Double(i * 25 + Int.random(in: -10...10))))
                                .modifier(FlameModifier(
                                    intensity: animationAmount * Double(i % 2 + 1) * 0.2,
                                    speed: Double(i % 3 + 1) * 0.5
                                ))
                        }
                    }
                    
                case "Earth":
                    // 山丘/土元素图形 - 更自然的非对称版本
                    ZStack {
                        ForEach(0..<4) { i in
                            NaturalMountainShape(seed: CGFloat(i))
                                .fill(getSwiftUIColor(for: selectedElementColors[i % selectedElementColors.count]))
                                .frame(width: CGFloat(180 + i * 30), height: CGFloat(100 + i * 20))
                                .offset(x: CGFloat(sin(Double(i)) * 120),
                                        y: CGFloat(cos(Double(i)) * 100) + 200)
                                .modifier(SwayingModifier(
                                    angle: animationAmount * 0.2,
                                    scale: 1.0
                                ))
                        }
                    }
                    
                case "Metal":
                    // 金属/钻石形状 - 更自然的非对称版本
                    ZStack {
                        ForEach(0..<6) { i in
                            NaturalDiamondShape(seed: CGFloat(i))
                                .fill(getSwiftUIColor(for: selectedElementColors[i % selectedElementColors.count]))
                                .frame(width: CGFloat(60 + i * 15), height: CGFloat(80 + i * 20))
                                .rotationEffect(Angle(degrees: Double(i * 30 + Int.random(in: -5...5))))
                                .offset(x: CGFloat(sin(Double(i)) * 140),
                                        y: CGFloat(cos(Double(i)) * 140))
                                .modifier(GlintModifier(
                                    animationAmount: animationAmount,
                                    delay: Double(i) * 0.5
                                ))
                        }
                    }
                    
                case "Water":
                    // 水滴形状 - 更自然的非对称版本
                    ZStack {
                        ForEach(0..<8) { i in
                            NaturalWaterdropShape(seed: CGFloat(i))
                                .fill(getSwiftUIColor(for: selectedElementColors[i % selectedElementColors.count]))
                                .frame(width: CGFloat(40 + i * 10), height: CGFloat(60 + i * 15))
                                .rotationEffect(Angle(degrees: Double(i * 45 + Int.random(in: -10...10))))
                                .offset(x: CGFloat(sin(Double(i)) * 160),
                                        y: CGFloat(cos(Double(i)) * 160))
                                .modifier(WaterDropModifier(
                                    animationAmount: animationAmount,
                                    speed: Double(i % 3 + 1) * 0.3,
                                    scale: 1.0 + sin(animationAmount * 0.5 + Double(i)) * 0.05
                                ))
                        }
                    }
                    
                default:
                    EmptyView()
                }
            }
        }
    }
    
    // 日期格式化函数
    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: selectedDate)
    }
    
    private func formattedDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: selectedDate)
    }

    private func updateLuckyColor() {
        let result = lunarHelper.getElementGeneratedElementAndColor(for: selectedDate)
        dayElement = result.dayElement
        generatedElement = result.generatedElement
        luckyColor = result.color

        // 更新农历日期字符串 (示例 - 实际应使用lunar-swift库获取)
        lunarDateString = "农历 三月十七" // 这里应替换为实际从lunar-swift获取的农历日期
        
        // 获取所有颜色并修正Wood的颜色列表（将Blue改为Olive）
        allElementColors = getModifiedElementColors()
        selectedElementColors = getModifiedColorsForElement(generatedElement)
    }

    private func getModifiedElementColors() -> [(element: String, colors: [String])] {
        [
            ("Wood", ["Green", "Teal", "Olive"]), // 将Blue改为Olive
            ("Fire", ["Red", "Purple", "Pink"]),
            ("Earth", ["Yellow", "Brown", "Beige"]),
            ("Metal", ["White", "Silver", "Gray"]),
            ("Water", ["Blue", "Navy", "Black"])
        ]
    }

    private func getModifiedColorsForElement(_ element: String) -> [String] {
        switch element {
        case "Wood":  return ["Green", "Teal", "Olive"] // 将Blue改为Olive
        case "Fire":  return ["Red", "Purple", "Pink"]
        case "Earth": return ["Yellow", "Brown", "Beige"]
        case "Metal": return ["White", "Silver", "Gray"]
        case "Water": return ["Blue", "Navy", "Black"]
        default:      return []
        }
    }

    private func getSwiftUIColor(for colorName: String) -> Color {
        switch colorName {
        case "Green":  return Color(red: 0.2, green: 0.8, blue: 0.4)
        case "Teal":   return Color(red: 0.2, green: 0.6, blue: 0.6)
        case "Olive":  return Color(red: 0.5, green: 0.6, blue: 0.3)
        case "Blue":   return Color(red: 0.2, green: 0.5, blue: 0.8)
        case "Navy":   return Color(red: 0.1, green: 0.2, blue: 0.5)
        case "Red":    return Color(red: 0.9, green: 0.2, blue: 0.3)
        case "Purple": return Color(red: 0.7, green: 0.2, blue: 0.8)
        case "Pink":   return Color(red: 0.9, green: 0.4, blue: 0.6)
        case "Yellow": return Color(red: 0.95, green: 0.8, blue: 0.2)
        case "Brown":  return Color(red: 0.6, green: 0.4, blue: 0.2)
        case "Beige":  return Color(red: 0.96, green: 0.96, blue: 0.86)
        case "White":  return Color(white: 0.95)
        case "Silver": return Color(red: 0.8, green: 0.8, blue: 0.85)
        case "Gray":   return Color(red: 0.6, green: 0.6, blue: 0.6)
        case "Black":  return Color(red: 0.15, green: 0.15, blue: 0.15)
        default:       return Color.gray
        }
    }
}

// ============ 动画修饰器 ============

// 摇摆动画修饰器 - 适用于树叶等元素
struct SwayingModifier: AnimatableModifier {
    var angle: Double
    var scale: CGFloat
    
    var animatableData: Double {
        get { angle }
        set { angle = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle(degrees: sin(angle) * 2))
            .scaleEffect(scale)
    }
}

// 火焰跳动修饰器
struct FlameModifier: AnimatableModifier {
    var intensity: Double
    var speed: Double
    
    var animatableData: Double {
        get { intensity }
        set { intensity = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(1.0 + sin(intensity * speed) * 0.05, anchor: .bottom)
            .offset(y: sin(intensity * speed) * 3)
    }
}

// 金属闪光修饰器
struct GlintModifier: AnimatableModifier {
    var animationAmount: Double
    var delay: Double
    
    var animatableData: Double {
        get { animationAmount }
        set { animationAmount = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle(degrees: sin(animationAmount + delay) * 1.5))
            .brightness(sin(animationAmount * 2 + delay) * 0.05)
    }
}

// 水滴动画修饰器
struct WaterDropModifier: AnimatableModifier {
    var animationAmount: Double
    var speed: Double
    var scale: CGFloat
    
    var animatableData: Double {
        get { animationAmount }
        set { animationAmount = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .offset(x: sin(animationAmount * speed) * 3, y: cos(animationAmount * speed) * 3)
    }
}

// ============ 更自然的形状 ============

// 自然的叶子形状
struct NaturalLeafShape: Shape {
    var seed: CGFloat  // 用于让每个叶子形状不同
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        // 添加随机变化使叶子看起来更自然
        let tipOffset = CGFloat.random(in: -0.1...0.1) * width
        let leftBulge = CGFloat.random(in: 0.8...1.2)
        let rightBulge = CGFloat.random(in: 0.8...1.2)
        
        path.move(to: CGPoint(x: width/2 + tipOffset, y: 0))
        
        // 叶子右侧
        path.addQuadCurve(
            to: CGPoint(x: width, y: height/2 + CGFloat.random(in: -10...10)),
            control: CGPoint(x: width * rightBulge, y: height * 0.3 * CGFloat.random(in: 0.8...1.2))
        )
        
        // 叶子底部
        path.addQuadCurve(
            to: CGPoint(x: width/2 + CGFloat.random(in: -5...5), y: height),
            control: CGPoint(x: width * 0.8, y: height * CGFloat.random(in: 0.9...1.1))
        )
        
        // 叶子左侧
        path.addQuadCurve(
            to: CGPoint(x: 0, y: height/2 + CGFloat.random(in: -10...10)),
            control: CGPoint(x: width * 0.2, y: height * leftBulge * 0.7)
        )
        
        // 回到顶部
        path.addQuadCurve(
            to: CGPoint(x: width/2 + tipOffset, y: 0),
            control: CGPoint(x: width * 0.2 * CGFloat.random(in: 0.8...1.2), y: height * 0.2)
        )
        
        // 添加叶脉
        let midY = height * 0.5 + CGFloat.random(in: -10...10)
        
        return path
    }
}

// 自然的火焰形状
struct NaturalFlameShape: Shape {
    var seed: CGFloat  // 用于让每个火焰形状不同
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        // 添加随机变化使火焰看起来更自然不规则
        let tipOffset = CGFloat.random(in: -0.1...0.1) * width
        let leftWidth = CGFloat.random(in: 0.15...0.25) * width
        let rightWidth = CGFloat.random(in: 0.75...0.85) * width
        
        path.move(to: CGPoint(x: width/2 + tipOffset, y: 0))
        
        // 左侧曲线
        path.addQuadCurve(
            to: CGPoint(x: leftWidth, y: height * 0.6 + CGFloat.random(in: -10...10)),
            control: CGPoint(x: width * 0.2, y: height * 0.4 * CGFloat.random(in: 0.8...1.2))
        )
        
        // 底部左侧
        path.addQuadCurve(
            to: CGPoint(x: width * 0.25 + CGFloat.random(in: -5...10), y: height),
            control: CGPoint(x: leftWidth * 0.5, y: height * 0.8)
        )
        
        // 底部中间
        path.addQuadCurve(
            to: CGPoint(x: width * 0.75 + CGFloat.random(in: -10...5), y: height),
            control: CGPoint(x: width/2, y: height - CGFloat.random(in: 5...15))
        )
        
        // 底部右侧
        path.addQuadCurve(
            to: CGPoint(x: rightWidth, y: height * 0.6 + CGFloat.random(in: -10...10)),
            control: CGPoint(x: width * 0.85, y: height * 0.8)
        )
        
        // 回到顶部
        path.addQuadCurve(
            to: CGPoint(x: width/2 + tipOffset, y: 0),
            control: CGPoint(x: width * 0.8, y: height * 0.4 * CGFloat.random(in: 0.8...1.2))
        )
        
        return path
    }
}

// 自然的山形
struct NaturalMountainShape: Shape {
    var seed: CGFloat  // 用于让每个山形不同
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        // 基础点
        path.move(to: CGPoint(x: 0, y: height))
        
        // 第一个山峰
        let peak1X = width * CGFloat.random(in: 0.2...0.4)
        let peak1Y = height * CGFloat.random(in: 0.2...0.4)
        path.addQuadCurve(
            to: CGPoint(x: peak1X, y: peak1Y),
            control: CGPoint(x: width * 0.1, y: height * 0.7)
        )
        
        // 山谷
        let valleyX = width * CGFloat.random(in: 0.45...0.55)
        let valleyY = height * CGFloat.random(in: 0.5...0.7)
        path.addQuadCurve(
            to: CGPoint(x: valleyX, y: valleyY),
            control: CGPoint(x: (peak1X + valleyX)/2, y: peak1Y + CGFloat.random(in: 5...15))
        )
        
        // 第二个山峰
        let peak2X = width * CGFloat.random(in: 0.6...0.8)
        let peak2Y = height * CGFloat.random(in: 0.3...0.5)
        path.addQuadCurve(
            to: CGPoint(x: peak2X, y: peak2Y),
            control: CGPoint(x: (valleyX + peak2X)/2, y: peak2Y - CGFloat.random(in: 5...20))
        )
        
        // 最后的下降
        path.addQuadCurve(
            to: CGPoint(x: width, y: height),
            control: CGPoint(x: width * 0.9, y: height * 0.7)
        )
        
        path.closeSubpath()
        
        return path
    }
}

// 自然的钻石形状
struct NaturalDiamondShape: Shape {
    var seed: CGFloat  // 用于让每个钻石形状不同
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        // 顶点添加少量随机变化
        let topX = width/2 + CGFloat.random(in: -5...5)
        let rightX = width * CGFloat.random(in: 0.95...1.0)
        let rightY = height/2 + CGFloat.random(in: -5...5)
        let bottomX = width/2 + CGFloat.random(in: -5...5)
        let leftX = width * CGFloat.random(in: 0...0.05)
        let leftY = height/2 + CGFloat.random(in: -5...5)
        
        // 不规则的八边形
        path.move(to: CGPoint(x: topX, y: 0))
        path.addLine(to: CGPoint(x: width * 0.75 + CGFloat.random(in: -5...5), y: height * 0.25 + CGFloat.random(in: -5...5)))
        path.addLine(to: CGPoint(x: rightX, y: rightY))
        path.addLine(to: CGPoint(x: width * 0.75 + CGFloat.random(in: -5...5), y: height * 0.75 + CGFloat.random(in: -5...5)))
        path.addLine(to: CGPoint(x: bottomX, y: height))
        path.addLine(to: CGPoint(x: width * 0.25 + CGFloat.random(in: -5...5), y: height * 0.75 + CGFloat.random(in: -5...5)))
        path.addLine(to: CGPoint(x: leftX, y: leftY))
        path.addLine(to: CGPoint(x: width * 0.25 + CGFloat.random(in: -5...5), y: height * 0.25 + CGFloat.random(in: -5...5)))
        path.closeSubpath()
        
        return path
    }
}

// 自然的水滴形状
struct NaturalWaterdropShape: Shape {
    var seed: CGFloat  // 用于让每个水滴形状不同
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        // 添加随机变化使水滴看起来更自然
        let tipOffset = CGFloat.random(in: -0.05...0.05) * width
        
        path.move(to: CGPoint(x: width/2 + tipOffset, y: 0))
        
        // 右侧曲线
        let rightControlX1 = width * CGFloat.random(in: 0.6...0.8)
        let rightControlY1 = height * CGFloat.random(in: 0.2...0.4)
        
        let rightX = width * CGFloat.random(in: 0.9...1.0)
        let rightY = height * CGFloat.random(in: 0.6...0.8)
        
        path.addCurve(
            to: CGPoint(x: rightX, y: rightY),
            control1: CGPoint(x: rightControlX1, y: rightControlY1),
            control2: CGPoint(x: width, y: height * 0.4)
        )
        
        // 底部曲线
        path.addCurve(
            to: CGPoint(x: width/2, y: height),
            control1: CGPoint(x: rightX, y: height * 0.9),
            control2: CGPoint(x: width * 0.75, y: height)
        )
        
        // 左侧曲线
        let leftX = width * CGFloat.random(in: 0...0.1)
        let leftY = height * CGFloat.random(in: 0.6...0.8)
        
        let leftControlX2 = width * CGFloat.random(in: 0.2...0.4)
        let leftControlY2 = height * CGFloat.random(in: 0.9...1.0)
        
        path.addCurve(
            to: CGPoint(x: leftX, y: leftY),
            control1: CGPoint(x: width * 0.25, y: height),
            control2: CGPoint(x: leftControlX2, y: leftControlY2)
        )
        
        // 回到顶部
        let leftControlX1 = width * CGFloat.random(in: 0.2...0.4)
        let leftControlY1 = height * CGFloat.random(in: 0.2...0.4)
        
        path.addCurve(
            to: CGPoint(x: width/2 + tipOffset, y: 0),
            control1: CGPoint(x: 0, y: height * 0.4),
            control2: CGPoint(x: leftControlX1, y: leftControlY1)
        )
        
        return path
    }
}

// 增强的颜色选项组件 - 添加点击功能
struct ColorOptionEnhanced: View {
    let color: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 6) {
            // 颜色圆形
            ZStack {
                Circle()
                    .fill(getSwiftUIColor(for: color))
                    .frame(width: 40, height: 40)
                
                if isSelected {
                    Circle()
                        .strokeBorder(Color.white, lineWidth: 2)
                        .frame(width: 40, height: 40)
                    
                    Circle()
                        .fill(Color.white)
                        .frame(width: 12, height: 12)
                }
            }
            .shadow(color: isSelected ? Color.black.opacity(0.2) : Color.clear, radius: 4, x: 0, y: 2)
            .onTapGesture {
                onTap()
            }
            
            // 颜色名称 - 移除阴影
            Text(color)
                .font(.system(size: 10))
                .fontWeight(isSelected ? .medium : .regular)
                .foregroundColor(isSelected ? .white : .white.opacity(0.7))
        }
    }
    
    func getSwiftUIColor(for colorName: String) -> Color {
        switch colorName {
        case "Green":  return Color(red: 0.2, green: 0.8, blue: 0.4)
        case "Teal":   return Color(red: 0.2, green: 0.6, blue: 0.6)
        case "Olive":  return Color(red: 0.5, green: 0.6, blue: 0.3)
        case "Blue":   return Color(red: 0.2, green: 0.5, blue: 0.8)
        case "Navy":   return Color(red: 0.1, green: 0.2, blue: 0.5)
        case "Red":    return Color(red: 0.9, green: 0.2, blue: 0.3)
        case "Purple": return Color(red: 0.7, green: 0.2, blue: 0.8)
        case "Pink":   return Color(red: 0.9, green: 0.4, blue: 0.6)
        case "Yellow": return Color(red: 0.95, green: 0.8, blue: 0.2)
        case "Brown":  return Color(red: 0.6, green: 0.4, blue: 0.2)
        case "Beige":  return Color(red: 0.96, green: 0.96, blue: 0.86)
        case "White":  return Color(white: 0.95)
        case "Silver": return Color(red: 0.8, green: 0.8, blue: 0.85)
        case "Gray":   return Color(red: 0.6, green: 0.6, blue: 0.6)
        case "Black":  return Color(red: 0.15, green: 0.15, blue: 0.15)
        default:       return Color.gray
        }
    }
}

// FiveElementsInfoView的定义保持不变
struct FiveElementsInfoView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Group {
                        Text("The Five Elements Theory")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("The Chinese Five Elements Theory (Wu Xing) is a fundamental concept in traditional Chinese philosophy. It categorizes natural phenomena into five groups: Wood, Fire, Earth, Metal, and Water.")
                    
                        Text("These elements interact with each other in two cycles:")
                            .fontWeight(.semibold)
                        
                        Text("Generative Cycle (相生):")
                            .fontWeight(.medium)
                        Text("• Wood feeds Fire")
                        Text("• Fire creates Earth (ash)")
                        Text("• Earth bears Metal")
                        Text("• Metal collects Water")
                        Text("• Water nourishes Wood")
                        
                        Text("Controlling Cycle (相克):")
                            .fontWeight(.medium)
                        Text("• Wood parts Earth")
                        Text("• Earth absorbs Water")
                        Text("• Water extinguishes Fire")
                        Text("• Fire melts Metal")
                        Text("• Metal chops Wood")
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    Group {
                        Text("Elements and Colors")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Each element is associated with specific colors:")
                        
                        Text("• Wood: Green, Teal, Olive")
                        Text("• Fire: Red, Purple, Pink")
                        Text("• Earth: Yellow, Brown, Beige")
                        Text("• Metal: White, Silver, Gray")
                        Text("• Water: Blue, Navy, Black")
                        
                        Text("This app suggests wearing the color of the element that is generated by today's element to enhance the natural energy flow.")
                            .italic()
                            .padding(.top, 5)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 20)
            }
            .navigationTitle("Five Elements Theory")
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

#Preview {
    ContentView()
}
