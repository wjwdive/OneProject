//
//  RelativeDateTimeFormatterType.swift
//  Moments
//
//  Created by wjw on 2025/5/28.
//

import Foundation

protocol RelativeDateTimeFormatterType {
    var unitsStyle: RelativeDateTimeFormatter.UnitsStyle { get set }

    func localizedString(for date: Date, relativeTo referenceDate: Date) -> String
}

extension RelativeDateTimeFormatter: RelativeDateTimeFormatterType { }


struct SocialMediaTimeFormatter {
    static func formattedTime(for date: Date, relativeTo referenceDate: Date = Date()) -> String {
        let interval = referenceDate.timeIntervalSince(date)
        let calendar = Calendar.current
        
        // 1. 刚刚发布
        if interval < 60 {
            return "刚刚"
        }
        
        // 2. 今天内
        if calendar.isDateInToday(date) {
            if interval < 3600 {
                let minutes = Int(interval / 60)
                return "\(minutes)分钟前"
            } else {
                let hours = Int(interval / 3600)
                return "\(hours)小时前"
            }
        }
        // 3. 昨天
        else if calendar.isDateInYesterday(date) {
            return "昨天"
        }
        // 4. 一周内（显示星期几）
        else if let days = calendar.dateComponents([.day], from: date, to: referenceDate).day, days < 7 {
            return weekdayFormatter.string(from: date)
        }
        // 5. 超过一周
        else {
            // 同年显示月日，跨年显示年月日
            if calendar.isDate(date, equalTo: referenceDate, toGranularity: .year) {
                return dateFormatter.string(from: date)
            } else {
                return yearDateFormatter.string(from: date)
            }
        }
    }
    
    // 修正：显示 "周一" 格式
    private static let weekdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE" // 使用 EEE 表示短格式星期
        formatter.locale = Locale(identifier: "zh_Hans_CN")
        return formatter
    }()
    
    // 月日格式 (e.g. "05-27")
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd"
        return formatter
    }()
    
    // 年月日格式 (e.g. "2025-05-27")
    private static let yearDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

struct FormatterStrToDate {
        // 方法 1：使用 DateFormatter（兼容所有 iOS 版本）
        static func dateFromISOString(_ string: String) -> Date? {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            return formatter.date(from: string)
        }
        
        // 方法 2：使用 ISO8601DateFormatter（iOS 10+ 更高效）
        @available(iOS 10.0, *)
        static func dateFromISOStringWithISOFormatter(_ string: String) -> Date? {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            return formatter.date(from: string)
        }
}

// 使用示例
//let postDate = Calendar.current.date(byAdding: .hour, value: -3, to: Date())!
//print(SocialMediaTimeFormatter.formattedTime(for: postDate)) // 输出 "3小时前"
