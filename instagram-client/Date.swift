//
//  DateExtension.swift
//  instagram-client
//
//  Created by kuzindmitry on 27.07.17.
//  Copyright © 2017 Dmitry Kuzin. All rights reserved.
//

import Foundation

extension Date {
    
    enum DateElementType {
        case year, month, week, day, hour, minute
    }
    
    var ago: String {
        let calendar = Calendar.current
        let today = Date()
        
        let components = calendar.dateComponents([.minute, .hour, .day, .weekOfYear, .month, .year], from: self, to: today)
        
        if let year = components.year, year >= 1 {
            return result(with: year, and: .year)
        } else if let month = components.month, month >= 1 {
            return result(with: month, and: .month)
        } else if let weekOfYear = components.weekOfYear, weekOfYear >= 1 {
            return result(with: weekOfYear, and: .week)
        } else if let day = components.day, day >= 1 {
            return result(with: day, and: .day)
        } else if let hour = components.hour, hour >= 1 {
            return result(with: hour, and: .hour)
        } else if let minute = components.minute, minute >= 1 {
            return result(with: minute, and: .minute)
        }
        return "Сейчас"
    }
    
    private func result(with count: Int, and type: DateElementType) -> String {
        let delta = count % 10
        return name(for: type, delta: delta, count: count)
    }
    
    private func name(for type: DateElementType, delta: Int, count: Int) -> String {
        if delta == 0 || (delta >= 5 && delta <= 9) || (count >= 5 && count <= 20) {
            switch type {
            case .year: return "\(count) лет назад"
            case .month: return "\(count) месяцев назад"
            case .week: return "\(count) недель назад"
            case .day: return "\(count) дней назад"
            case .hour: return "\(count) часов назад"
            case .minute: return "\(count) минут назад"
            }
            
        }
        if delta == 1 {
            switch type {
            case .year: return "\(count) год назад"
            case .month: return "\(count) месяц назад"
            case .week: return "\(count) неделю назад"
            case .day: return "\(count) день назад"
            case .hour: return "\(count) час назад"
            case .minute: return "\(count) минуту назад"
            }
        }
        if delta < 5 {
            switch type {
            case .year: return "\(count) года назад"
            case .month: return "\(count) месяца назад"
            case .week: return "\(count) недели назад"
            case .day: return "\(count) дня назад"
            case .hour: return "\(count) часа назад"
            case .minute: return "\(count) минуты назад"
            }
        }
        return ""
    }
}
