//
//  ColorForTodayWidgetBundle.swift
//  ColorForTodayWidget
//
//  Created by 陈艺凡 on 4/29/25.
//

import WidgetKit
import SwiftUI


struct ColorForTodayWidgetBundle: WidgetBundle {
    var body: some Widget {
        ColorForTodayWidget()
        ColorForTodayWidgetControl()
        ColorForTodayWidgetLiveActivity()
    }
}
