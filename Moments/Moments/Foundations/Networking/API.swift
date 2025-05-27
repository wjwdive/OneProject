//
//  API.swift
//  Moments
//
//  Created by wjw on 2025/5/26.
//

import Foundation
import RxSwift
import UIKit

enum API {
    //swiftlint:disable force_try
    //swiftlint:disable force_unwrapping
    //swiftlint:disable no_hardcoded_strings
    static let baseURL = try! URL(string: "https://" + Configuration.value(for: "API_BASE_URL"))!
    static let baseURL_LOCAL = try! URL(string: "http://" + Configuration.value(for: "API_BASE_URL_LOCAL"))!
    //swiftlint:enable force_try
    //swiftlint:enable force_unwrapping
    //swiftlint:enable no_hardcoded_strings
}
