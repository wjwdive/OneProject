//
//  GetMomentsByUserIDRestful.swift
//  Moments
//
//  Created by wjw on 2025/5/27.
//

import Foundation

import Alamofire
import RxSwift

//swiftlint:disable no_hardcoded_strings
struct GetMomentsByUserIDRestful: GetMomentsByUserIDSessionType {
//    struct Response: Codable {
//        let data: Data
//
//        struct Data: Codable {
//            let getMomentsDetailsByUserID: MomentsDetails
//        }
//    }
    
    struct Session: APISession {
        typealias ResponseType = BaseResponse<MomentsDetails>
        let path: String = API.baseURL.absoluteString + "/api/moments"
        let parameters: Parameters
        let headers: HTTPHeaders? = .init()
        //init Session  todo:
        init(userID: String, togglesDataStore: TogglesDataStoreType) {
            print("url path :" + path)
            // 设置请求参数
            self.parameters = [
                "userID": userID,
                "withLikes": togglesDataStore.isToggleOn(InternalToggle.isLikeButtonForMomentEnabled)
            ]
        }
    }
    private let togglesDataStore: TogglesDataStoreType
    //声明请求Session
    private let sessionHandler: (Session) -> Observable<BaseResponse<MomentsDetails>>
    
    //init GetMomentsByUserIDRestful, 请求方法参数：1、toggle开关，2、请求Session
    init(togglesDataStore: TogglesDataStoreType = InternalTogglesDataStore.shared, sessionHandler: @escaping (Session) -> Observable<BaseResponse<MomentsDetails>> = {
        $0.post($0.path, headers: $0.headers ?? HTTPHeaders.init(), parameters: $0.parameters)
    }) {
        self.togglesDataStore = togglesDataStore
        self.sessionHandler = sessionHandler
    }
    
    func getMoments(userID: String) -> Observable<MomentsDetails> {
        let session = Session(userID: userID, togglesDataStore: togglesDataStore)
        return sessionHandler(session).map {
            $0.data//MomentsDetails 整个数据返回给Repo
        }
    }
}
