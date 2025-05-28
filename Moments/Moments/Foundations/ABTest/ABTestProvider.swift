//
//  ABTestProvider.swift
//  Moments
//
//  Created by wjw on 2025/5/28.
//

import Foundation

enum LikeButtonStyle: String {
    case heart, star
}

protocol ABTestProvider {
    var likeButtonStyle: LikeButtonStyle? { get }
}
