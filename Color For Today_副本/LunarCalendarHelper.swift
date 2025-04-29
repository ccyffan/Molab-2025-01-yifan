//
//  LunarCalendarHelper.swift
//  Color For Today
//
//  Created by 陈艺凡 on 4/22/25.
//

import Foundation

class LunarCalendarHelper {
    // Ten Heavenly Stems in order
    let heavenlyStems = ["甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸"]
    
    // Get the Heavenly Stem for a specific date
    func getStem(for date: Date) -> String {
        // January 1, 2024 was a 甲子 day, where 甲 is the stem
        let knownDate = DateComponents(calendar: Calendar(identifier: .gregorian),
                                      year: 2024, month: 1, day: 1).date!
        
        // Calculate days since the known date
        let daysSinceKnownDate = Calendar.current.dateComponents([.day],
                                                               from: knownDate,
                                                               to: date).day!
        
        // Heavenly Stems cycle every 10 days
        let stemIndex = daysSinceKnownDate % 10
        // Handle negative cases (when date is before knownDate)
        let normalizedIndex = (stemIndex % 10 + 10) % 10
        
        return heavenlyStems[normalizedIndex]
    }
    
    // Get the Five Element, generated element, and lucky color based on the Heavenly Stem
    func getElementGeneratedElementAndColor(for stem: String) -> (dayElement: String, generatedElement: String, color: String) {
        switch stem {
        case "甲", "乙":  // Wood
            return ("Wood", "Fire", "Red")  // Wood generates Fire
        case "丙", "丁":  // Fire
            return ("Fire", "Earth", "Yellow")  // Fire generates Earth
        case "戊", "己":  // Earth
            return ("Earth", "Metal", "White")  // Earth generates Metal
        case "庚", "辛":  // Metal
            return ("Metal", "Water", "Blue")  // Metal generates Water
        case "壬", "癸":  // Water
            return ("Water", "Wood", "Green")  // Water generates Wood
        default:
            return ("Unknown", "Unknown", "Gray")
        }
    }
    
    // Get the elements and lucky color for a specific date
    func getElementGeneratedElementAndColor(for date: Date) -> (dayElement: String, generatedElement: String, color: String) {
        let stem = getStem(for: date)
        return getElementGeneratedElementAndColor(for: stem)
    }
}
    
    // 新增：获取所有五行对应的颜色
    func getAllElementColors() -> [(element: String, colors: [String])] {
        return [
            ("Wood", ["Green", "Blue", "Teal"]),
            ("Fire", ["Red", "Purple", "Pink"]),
            ("Earth", ["Yellow", "Brown", "Beige"]),
            ("Metal", ["White", "Silver", "Gray"]),
            ("Water", ["Black", "Dark Blue", "Navy"])
        ]
    }
    
    // 新增：获取特定元素的所有颜色
    func getColorsForElement(_ element: String) -> [String] {
        switch element {
        case "Wood":
            return ["Green", "Blue", "Teal"]
        case "Fire":
            return ["Red", "Purple", "Pink"]
        case "Earth":
            return ["Yellow", "Brown", "Beige"]
        case "Metal":
            return ["White", "Silver", "Gray"]
        case "Water":
            return ["Black", "Dark Blue", "Navy"]
        default:
            return []
        }
    }

