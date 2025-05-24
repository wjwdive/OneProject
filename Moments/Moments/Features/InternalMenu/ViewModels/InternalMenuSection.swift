//
//  InternalMenuSection.swift
//  Moments
//
//  Created by wjw on 2025/5/23.
//

import Foundation
import RxDataSources

struct InternalMenuSection: SectionModelType {
    let title: String
    let items: [InternalMenuItemViewModel]
    let footer: String?

    init(title: String, items: [InternalMenuItemViewModel], footer: String? = nil) {
        self.title = title
        self.items = items
        self.footer = footer
    }

    init(original: InternalMenuSection, items: [InternalMenuItemViewModel]) {
        self.init(title: original.title, items: items, footer: original.footer)
    }
}
