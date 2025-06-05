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
    #if DEBUG
//    static let baseURL = try! URL(string: "" + Configuration.value(for: "API_BASE_URL_LOCAL"))!
//    static let baseURL = try! URL(string: "" + "https://00q7zgjc-3000.asse.devtunnels.ms")
    static let baseURL = try! URL(string: "" + "http://192.168.0.102:3000")!
    //https://00q7zgjc-3000.asse.devtunnels.ms/
    #endif
    #if INTERNAL
    static let baseURL = try! URL(string: "https://" + Configuration.value(for: "API_BASE_URL"))!
    #endif

    #if PRODUCTION
    static let baseURL = try! URL(string: "https://" + Configuration.value(for: "API_BASE_URL"))!
    #endif
    //swiftlint:enable force_try
    //swiftlint:enable force_unwrapping
    //swiftlint:enable no_hardcoded_strings
}
