import WidgetKit
import SwiftUI

struct LuckyColorEntry: TimelineEntry {
    let date: Date
    let dayElement: String
    let generatedElement: String
    let luckyColor: String
}

struct LuckyColorProvider: TimelineProvider {
    let helper = LunarCalendarHelper()

    func placeholder(in context: Context) -> LuckyColorEntry {
        LuckyColorEntry(date: Date(), dayElement: "Wood", generatedElement: "Fire", luckyColor: "Red")
    }

    func getSnapshot(in context: Context, completion: @escaping (LuckyColorEntry) -> ()) {
        completion(makeEntry(for: Date()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<LuckyColorEntry>) -> ()) {
        let now = Date()
        let entry = makeEntry(for: now)
        let next = Calendar.current.nextDate(after: now, matching: DateComponents(hour: 0, minute: 5), matchingPolicy: .nextTime)!
        completion(Timeline(entries: [entry], policy: .after(next)))
    }

    private func makeEntry(for date: Date) -> LuckyColorEntry {
        let result = helper.getElementGeneratedElementAndColor(for: date)
        return LuckyColorEntry(date: date,
                               dayElement: result.dayElement,
                               generatedElement: result.generatedElement,
                               luckyColor: result.color)
    }
}

struct LuckyColorWidgetEntryView: View {
    var entry: LuckyColorEntry

    private func bgColor(for name: String) -> Color {
        switch name {
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
        default:        return .gray
        }
    }

    var body: some View {
        content
        #if os(iOS) && swift(>=5.9)
        .containerBackground(for: .widget) {
            bgColor(for: entry.luckyColor)
        }
        #else
        .background(
            ZStack {
                bgColor(for: entry.luckyColor)
                content
            }
        )
        #endif
    }

    private var content: some View {
        VStack(spacing: 8) {
            Text("Color For Today")
                .font(.system(.headline, design: .monospaced))
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                // Ensures text does not truncate with ellipsis
                .fixedSize(horizontal: false, vertical: false)

            Text(entry.luckyColor)
                .font(.system(.largeTitle, design: .monospaced))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Text("\(entry.dayElement) → \(entry.generatedElement)")
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

@main
struct ColorForTodayWidget: Widget {
    let kind: String = "ColorForTodayWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: LuckyColorProvider()) { entry in
            LuckyColorWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("幸运色小组件")
        .description("Quickly view today's lucky color and Five Elements information on your lock or home screen.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemSmall) {
    ColorForTodayWidget()
} timeline: {
    LuckyColorEntry(date: .now, dayElement: "Wood", generatedElement: "Fire", luckyColor: "Red")
    LuckyColorEntry(date: .now.addingTimeInterval(86_400), dayElement: "Fire", generatedElement: "Earth", luckyColor: "Yellow")
}
