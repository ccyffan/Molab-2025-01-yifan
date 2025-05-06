//  CalendarHeaderView.swift
//  ColorForToday
//
//  Created by 陈艺凡 on 2025/05/05.
//

import SwiftUI

struct CalendarHeaderView: View {
    let date: Date

    // MARK: - 各种格式化处理（西历、星期、农历）
    private var monthName: String {
        let df = DateFormatter()
        df.dateFormat = "LLLL"    // 全写月份
        return df.string(from: date)
    }
    private var dayNumber: String {
        let df = DateFormatter()
        df.dateFormat = "d"       // 号数
        return df.string(from: date)
    }
    private var weekdayName: String {
        let df = DateFormatter()
        df.dateFormat = "EEEE"    // 星期几
        return df.string(from: date)
    }
    private var lunarDayText: String {
        // 用系统中国农历日历来格式化
        let df = DateFormatter()
        df.calendar = Calendar(identifier: .chinese)
        df.locale = Locale(identifier: "zh_CN")
        df.dateFormat = "MMMM d"  // 会输出“正月 初五”这类格式
        return df.string(from: date)
    }

    var body: some View {
        ZStack {
            // 背景渐变
            LinearGradient(
                gradient: Gradient(colors: [Color.yellow.opacity(0.3),
                                            Color.pink.opacity(0.2)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .cornerRadius(20)

            VStack(alignment: .leading, spacing: 8) {
                // 月份
                Text(monthName)
                    .font(.system(size: 24,
                                  weight: .regular,
                                  design: .serif))
                    .foregroundColor(.black.opacity(0.7))

                HStack(alignment: .firstTextBaseline) {
                    // 大日期
                    Text(dayNumber)
                        .font(.system(size: 100,
                                      weight: .regular,
                                      design: .serif))
                        .foregroundColor(.black)
                        .lineLimit(1)

                    Spacer()

                    // 星期 + 农历
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(weekdayName)
                        Text(lunarDayText)
                    }
                    .font(.system(size: 14,
                                  weight: .regular,
                                  design: .default))  // 改为 default
                    .foregroundColor(.black.opacity(0.8))
                }
            }
            .padding(20)
        }
        .frame(height: 180)
        .padding(.horizontal)
    }
}

// 预览
struct CalendarHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarHeaderView(date: Date())
            .previewLayout(.sizeThatFits)
    }
}
