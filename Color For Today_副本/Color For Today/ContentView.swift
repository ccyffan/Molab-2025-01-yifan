////
//  ContentView.swift
//  Color For Today
//
//  Created by 陈艺凡 on 4/22/25.
//

import SwiftUI
import LunarSwift

struct ContentView: View {
    // State variables
    @State private var selectedDate = Date()
    @State private var dateString = ""
    @State private var dayElement = ""
    @State private var generatedElement = ""
    @State private var luckyColor = ""
    @State private var showingInfo = false

    // Expanded color options
    @State private var allElementColors: [(element: String, colors: [String])] = []
    @State private var selectedElementColors: [String] = []

    private let lunarHelper = LunarCalendarHelper()

    var body: some View {
        ZStack {
            // 整页动态背景：幸运色渐变
            let bg = getSwiftUIColor(for: luckyColor)
            LinearGradient(
                gradient: Gradient(colors: [bg.opacity(0.6), bg.opacity(0.2)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 30) {
                    // 标题 + 装饰环
                    ZStack {
                        RadialGradient(
                            gradient: Gradient(colors: [bg.opacity(0.3), .clear]),
                            center: .topLeading,
                            startRadius: 20,
                            endRadius: 200
                        )
                        .frame(width: 260, height: 260)
                        .offset(x: -100, y: -100)

                        Text("Color of the Day")
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                            .shadow(radius: 0)
                    }
                    .padding(.top, 20)

                    // 日期卡片
                    sectionCard {
                        VStack {
                            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .labelsHidden()
                                .onChange(of: selectedDate) { _ in updateLuckyColor() }

                            Text(dateString)
                                .font(.headline)
                                .padding(.top, 5)
                        }
                    }

                    // 元素信息卡片
                    sectionCard {
                        VStack(spacing: 12) {
                            Text("Today's Element: \(dayElement)")
                                .font(.title3)
                            Text("Generates: \(generatedElement)")
                                .font(.title3)
                        }
                    }

                    // 幸运色显示卡片
                    sectionCard {
                        VStack(spacing: 15) {
                            Text("Lucky Color")
                                .font(.headline)
                            Text(luckyColor)
                                .font(.system(size: 28, weight: .semibold))
                            RoundedRectangle(cornerRadius: 20)
                                .fill(bg)
                                .frame(width: 150, height: 150)
                                .shadow(radius: 8)
                        }
                        .padding(.vertical, 10)
                    }

                    // 五行颜色总览卡片
                    sectionCard {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("All Element Colors")
                                .font(.headline)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(allElementColors, id: \.element) { info in
                                        ElementColorCard(
                                            element: info.element,
                                            colors: info.colors,
                                            isRecommended: info.element == generatedElement
                                        )
                                    }
                                }
                            }
                            .frame(height: 100)

                            if !selectedElementColors.isEmpty {
                                Text("Color Options for \(generatedElement)")
                                    .font(.headline)
                                    .padding(.top, 5)
                                HStack(spacing: 15) {
                                    ForEach(selectedElementColors, id: \.self) { color in
                                        ColorOption(color: color, isSelected: color == luckyColor)
                                    }
                                }
                            }
                        }
                    }

                    // 操作按钮
                    HStack(spacing: 20) {
                        Button {
                            selectedDate = Date()
                            updateLuckyColor()
                        } label: {
                            Label("Return to Today", systemImage: "calendar")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.blue, .purple]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .foregroundColor(.white)
                                .cornerRadius(15)
                        }

                        Button {
                            showingInfo = true
                        } label: {
                            Label("About", systemImage: "info.circle")
                                .padding()
                                .frame(width: 100)
                                .background(Color.white.opacity(0.2))
                                .foregroundColor(.white)
                                .cornerRadius(15)
                        }
                    }
                    .padding(.vertical, 20)
                }
                .padding(.horizontal)
            }
        }
        .onAppear { updateLuckyColor() }
        .sheet(isPresented: $showingInfo) {
            FiveElementsInfoView()
        }
    }

    // 通用卡片样式
    @ViewBuilder
    private func sectionCard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .padding()
            .background(Color(.systemBackground).opacity(0.8))
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }

    // 恢复原有日期+五行逻辑
    private func updateLuckyColor() {
        // —— 日期格式（原有回退）
        let df = DateFormatter()
        df.dateStyle = .medium
        dateString = df.string(from: selectedDate)

        // —— 五行/幸运色 逻辑
        let result = lunarHelper.getElementGeneratedElementAndColor(for: selectedDate)
        dayElement = result.dayElement
        generatedElement = result.generatedElement
        luckyColor = result.color

        allElementColors = getAllElementColors()
        selectedElementColors = getColorsForElement(generatedElement)
    }

    // 下面的辅助方法保持不变…
    private func getAllElementColors() -> [(element: String, colors: [String])] {
        [
            ("Wood", ["Green", "Blue", "Teal"]),
            ("Fire", ["Red", "Purple", "Pink"]),
            ("Earth", ["Yellow", "Brown", "Beige"]),
            ("Metal", ["White", "Silver", "Gray"]),
            ("Water", ["Blue", "Black", "Navy"])
        ]
    }

    private func getColorsForElement(_ element: String) -> [String] {
        switch element {
        case "Wood":  return ["Green", "Blue", "Teal"]
        case "Fire":  return ["Red", "Purple", "Pink"]
        case "Earth": return ["Yellow", "Brown", "Beige"]
        case "Metal": return ["White", "Silver", "Gray"]
        case "Water": return ["Blue", "Black", "Navy"]
        default:      return []
        }
    }

    private func getSwiftUIColor(for colorName: String) -> Color {
        switch colorName {
        case "Green":  return .green
        case "Blue":   return .blue
        case "Teal":   return Color(red: 0, green: 0.5, blue: 0.5)
        case "Red":    return .red
        case "Purple": return .purple
        case "Pink":   return .pink
        case "Yellow": return .yellow
        case "Brown":  return Color(red: 0.6, green: 0.4, blue: 0.2)
        case "Beige":  return Color(red: 0.96, green: 0.96, blue: 0.86)
        case "White":  return Color(white: 0.9)
        case "Silver": return Color(white: 0.8)
        case "Gray":   return .gray
        case "Black":  return .black
        case "Navy":   return Color(red: 0, green: 0, blue: 0.5)
        default:       return .gray
        }
    }
}

// 其他组件 ElementColorCard、ColorOption、FiveElementsInfoView 均不变…



// New component: Element color card
struct ElementColorCard: View {
    let element: String
    let colors: [String]
    let isRecommended: Bool
    
    var body: some View {
        VStack(spacing: 6) {
            Text(element)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isRecommended ? .white : .primary)
            
            HStack(spacing: 6) {
                ForEach(colors, id: \.self) { color in
                    RoundedRectangle(cornerRadius: 6)
                        .fill(getSwiftUIColor(for: color))
                        .frame(width: 24, height: 24)
                        .shadow(radius: 1)
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isRecommended ? Color.blue : Color(.systemGray6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isRecommended ? Color.blue : Color.clear, lineWidth: 2)
        )
    }
    
    func getSwiftUIColor(for colorName: String) -> Color {
        switch colorName {
        case "Green":
            return Color.green
        case "Blue":
            return Color.blue
        case "Teal":
            return Color(red: 0, green: 0.5, blue: 0.5)
        case "Red":
            return Color.red
        case "Purple":
            return Color.purple
        case "Pink":
            return Color.pink
        case "Yellow":
            return Color.yellow
        case "Brown":
            return Color(red: 0.6, green: 0.4, blue: 0.2)
        case "Beige":
            return Color(red: 0.96, green: 0.96, blue: 0.86)
        case "White":
            return Color(white: 0.9)
        case "Silver":
            return Color(white: 0.8)
        case "Gray":
            return Color.gray
        case "Black":
            return Color.black
        case "Navy":
            return Color(red: 0, green: 0, blue: 0.5)
        default:
            return Color.gray
        }
    }
}

// New component: Color option
struct ColorOption: View {
    let color: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 5) {
            Circle()
                .fill(getSwiftUIColor(for: color))
                .frame(width: 40, height: 40)
                .overlay(
                    Circle()
                        .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                )
                .shadow(radius: 2)
            
            Text(color)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
            
        }
    }
    
    func getSwiftUIColor(for colorName: String) -> Color {
        switch colorName {
        case "Green":
            return Color.green
        case "Blue":
            return Color.blue
        case "Teal":
            return Color(red: 0, green: 0.5, blue: 0.5)
        case "Red":
            return Color.red
        case "Purple":
            return Color.purple
        case "Pink":
            return Color.pink
        case "Yellow":
            return Color.yellow
        case "Brown":
            return Color(red: 0.6, green: 0.4, blue: 0.2)
        case "Beige":
            return Color(red: 0.96, green: 0.96, blue: 0.86)
        case "White":
            return Color(white: 0.9)
        case "Silver":
            return Color(white: 0.8)
        case "Gray":
            return Color.gray
        case "Black":
            return Color.black
        case "Navy":
            return Color(red: 0, green: 0, blue: 0.5)
        default:
            return Color.gray
        }
    }
}

// View with information about the Five Elements theory
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
                        
                        Text("• Wood: Green, Blue, Teal")
                        Text("• Fire: Red, Purple, Pink")
                        Text("• Earth: Yellow, Brown, Beige")
                        Text("• Metal: White, Silver, Gray")
                        Text("• Water: Black, Blue, Navy")
                        
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
