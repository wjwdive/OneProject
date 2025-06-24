//
//  GetUserInfoByUserIdRestful.swift
//  Moments
//
//  Created by wjw on 2025/06/04.
//

import Foundation

import Alamofire
import RxSwift

protocol GetUserInfoByUserIDSessionType {
    func getUserInfo(userID: String) -> Observable<UserInfoModel>
}

//swiftlint:disable no_hardcoded_strings
struct GetUserInfoByUserIdRestful: GetUserInfoByUserIDSessionType {
    struct Session: APISession {
        typealias ResponseType = BaseResponse<UserInfoModel>
        let path: String = API.baseURL.absoluteString + "/api/moments/user"
        let parameters: Parameters
        let headers: HTTPHeaders? = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        init(userID: String) {
            print("GetUserInfoByUserIdRestful: Creating session with userID: \(userID)")
            print("GetUserInfoByUserIdRestful: Request path: \(path)")
            print("GetUserInfoByUserIdRestful: Headers: \(String(describing: headers))")
            
            self.parameters = [
                "userId": userID
            ]
            print("GetUserInfoByUserIdRestful: Parameters: \(parameters)")
        }
    }
    
    private let sessionHandler: (Session) -> Observable<BaseResponse<UserInfoModel>>
    
    init(sessionHandler: @escaping (Session) -> Observable<BaseResponse<UserInfoModel>> = {
        print("GetUserInfoByUserIdRestful: Making network request")
        return $0.post($0.path, headers: $0.headers ?? HTTPHeaders.init(), parameters: $0.parameters)
    }) {
        self.sessionHandler = sessionHandler
    }
    
    func getUserInfo(userID: String) -> Observable<UserInfoModel> {
        print("GetUserInfoByUserIdRestful: getUserInfo called with userID: \(userID)")
        let session = Session(userID: userID)
        return sessionHandler(session)
            .do(onNext: { response in
                print("GetUserInfoByUserIdRestful: Received response: \(response)")
            }, onError: { error in
                print("GetUserInfoByUserIdRestful: Error: \(error)")
                if let afError = error as? AFError {
                    print("GetUserInfoByUserIdRestful: AFError details: \(afError)")
                }
            })
            .map { response in
                guard let data = response.data else {
                    throw AuthError.serverError // 或自定义“无数据”错误
                }
                return data
            }
    }
}
