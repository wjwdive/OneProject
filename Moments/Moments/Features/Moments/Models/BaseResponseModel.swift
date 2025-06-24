//
//  BaseResponseModel.swift
//  Moments
//
//  Created by wjw on 2025/5/29.
//

import Foundation

struct BaseResponse<T: Codable>: Codable {
    let data: T?
    let statusCode: Int
    let message: String
}
