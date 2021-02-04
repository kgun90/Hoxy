//
//  Date.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/01.
//

import Foundation

extension Date {
    var relativeTime_abbreviated: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.locale = Locale(identifier: "ko")
        return formatter.localizedString(for: self, relativeTo: Date())
    }
    
    var nearest30Min: Date {
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        guard let hours = dateComponents.hour else { return self }

        switch dateComponents.minute ?? 0 {
        case 0...14:
            dateComponents.minute = 0
        case 15...44:
            dateComponents.minute = 30
        case 44...59:
            dateComponents.minute = 0
            dateComponents.hour = hours + 1
        default:
            break
        }

        return dateComponents.date ?? self
    }
}

