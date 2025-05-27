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
    struct Response: Codable {
        let data: Data
        
        struct Data: Codable {
            let getMomentsDetailsByUserID: MomentsDetails
        }
    }
    
    struct Session: APISession {
        typealias ResponseType = Response
        let path: String = API.baseURL_LOCAL.absoluteString + "/api/moments"
        let parameters: Parameters
        let headers: HTTPHeaders? = .init()
        //init Session  todo:
        init(userID: String, togglesDataStore: TogglesDataStoreType) {
            
            // 设置请求参数
            self.parameters = [
                "userID": userID,
                "withLikes": togglesDataStore.isToggleOn(InternalToggle.isLikeButtonForMomentEnabled)
            ]
        }
    }
    private let togglesDataStore: TogglesDataStoreType
    private let sessionHandler: (Session) -> Observable<Response>
    
    //init GetMomentsByUserIDRestful
    init(togglesDataStore: TogglesDataStoreType = InternalTogglesDataStore.shared, sessionHandler: @escaping (Session) -> Observable<Response> = {
        $0.post($0.path, headers: $0.headers ?? HTTPHeaders.init(), parameters: $0.parameters)
    }) {
        self.togglesDataStore = togglesDataStore
        self.sessionHandler = sessionHandler
    }
    
    func getMoments(userID: String) -> Observable<MomentsDetails> {
        let session = Session(userID: userID, togglesDataStore: togglesDataStore)
        return sessionHandler(session).map {
            $0.data.getMomentsDetailsByUserID
        }
    }
}
