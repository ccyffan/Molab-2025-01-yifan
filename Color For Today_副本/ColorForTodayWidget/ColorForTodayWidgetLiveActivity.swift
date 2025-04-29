//
//  ColorForTodayWidgetLiveActivity.swift
//  ColorForTodayWidget
//
//  Created by 陈艺凡 on 4/29/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct ColorForTodayWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct ColorForTodayWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ColorForTodayWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension ColorForTodayWidgetAttributes {
    fileprivate static var preview: ColorForTodayWidgetAttributes {
        ColorForTodayWidgetAttributes(name: "World")
    }
}

extension ColorForTodayWidgetAttributes.ContentState {
    fileprivate static var smiley: ColorForTodayWidgetAttributes.ContentState {
        ColorForTodayWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: ColorForTodayWidgetAttributes.ContentState {
         ColorForTodayWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: ColorForTodayWidgetAttributes.preview) {
   ColorForTodayWidgetLiveActivity()
} contentStates: {
    ColorForTodayWidgetAttributes.ContentState.smiley
    ColorForTodayWidgetAttributes.ContentState.starEyes
}
