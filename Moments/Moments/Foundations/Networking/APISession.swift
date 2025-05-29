//
//  APISession.swift
//  Moments
//
//  Created by wjw on 2025/5/26.
//

import Foundation
import Alamofire
import RxSwift

enum APISessionError: Error {
    case networkError(error: Error, statuseCode: Int)
    case invalidJSON
    case noData
}

protocol APISession {
    associatedtype ResponseType: Decodable
    ///为什么Observable存放的是ReponseType类型呢？由于APISession并不知道每一个网络请求返回数据的具体类型，因此使用associatedtype来定义ReponseType，以迫使所有遵循它的实现类型都必须指定ReponseType的具体数据类型。
    func post(
        _ path: String,
        headers: HTTPHeaders,
        parameters: Parameters?
    ) -> Observable<ResponseType>
        
}

/// 为了方便共享 HTTP 网络请求的功能，我们为APISession定义了协议扩展，并给post(_ path: String, parameters: Parameters?, headers: HTTPHeaders) -> Observable<ReponseType>方法提供默认的实现。
extension APISession {
    var defaultHeaders: HTTPHeaders {
        //swiftlint:disable no_hardcoded_strings
        let headers: HTTPHeaders = [
            "x-app-platform": "iOS",
            "x-app-version": UIApplication.appVersion,
            "x-os-version": UIDevice.current.systemVersion
            ]
        //swiftlint:enable no_hardcoded_strings
        return headers
    }
    
    var baseUrl: URL {
        return API.baseURL
    }
    
    func post(_ path: String, headers: HTTPHeaders = [:], parameters: Parameters? = nil) -> Observable<ResponseType> {
        return request(path, method: .post, headers: headers, parameters: parameters, encoding: JSONEncoding.default)
    }
}

/// 私有扩展 定义了名叫request(...)  来支持 HTTP 的其他 Method. 有了request()方法，我们就可以支持不同的 HTTP Method 了。如果需要支持 HTTP GET 请求的时候，只需把HTTPMethod.get传递给该方法就可以了。
    /// 1 我们首先使用Observable.create()方法来创建一个 Observable 序列并返回给调用者，
    /// 2 然后在create()方法的封包里使用 Alamofire 的request()方法发起网络请求。
    /// 3 为了不阻挡 UI 的响应，我们把该请求安排到后台队列中执行。
    /// 4 当我们得到返回的 JSON 以后，进行解码处理。
private extension APISession {
    func request(
        _ path: String,
        method: HTTPMethod,
        headers: HTTPHeaders,
        parameters: Parameters?,
        encoding: ParameterEncoding
    ) -> Observable<ResponseType> {
        
        let url = path
        //合并默认 headers 和当前请求 headers，如果有重复的 key，以当前请求的为准
        let allHeaders = HTTPHeaders(defaultHeaders.dictionary.merging(headers.dictionary) { $1 })
        // {(_, new) in new }) 可替换为 { $1 }
        
        return Observable.create { observer -> Disposable in
            //swiftlint: disable no_hardcoded_strings
            let queue = DispatchQueue(label: "APISessionRequestQueue", qos: .background, attributes: .concurrent)
            //swiftlint: enable no_hardcoded_strings
            
            let request = AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: allHeaders, interceptor: nil, requestModifier: nil)
                .validate()//statusCode: 200..<300
                .responseJSON(queue: queue) { response in
                    switch response.result {
                    case .success:
                        guard let data = response.data else {
                            //if no error provided by Alamofire, return .noData error instead
                            observer.onError(response.error ?? APISessionError.noData)
                            return
                        }
                        do {
                            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                               let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
                               let prettyString = String(data: prettyData, encoding: .utf8) {
                               print("response json:--------\n" + prettyString)
                                let model = try JSONDecoder().decode(ResponseType.self, from: data)
                                observer.onNext(model)
                                observer.onCompleted()
                            } else {
                                print("无法格式化打印 JSON")
                            }
                        } catch {
                            observer.onError(error)
                        }
                    case .failure(let error):
                        if let statusCode = response.response?.statusCode {
                            observer.onError(APISessionError.networkError(error: error, statuseCode: statusCode))
                        } else {
                            observer.onError(error)
                        }
                    }
                }
            return Disposables.create {
                request.cancel()
            }
        }.debug("request log:--------")   //return Observable.create end
    }//func request end
}

