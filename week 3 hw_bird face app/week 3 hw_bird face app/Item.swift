//
//  Item.swift
//  week 3 hw_bird face app
//
//  Created by 陈艺凡 on 2/10/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
