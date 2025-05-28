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
