//
//  GetUserInfoByIDMoya.swift
//  Moments
//
//  Created by wjw on 2025/6/11.
//

import Foundation

import Moya
import RxSwift
import RxCocoa

///  使用moya进行网络请求

// MARK: - API 枚举
enum AuthAPI {
    case getUsers(page: Int)
    case getUser(id: Int)
    case login(username: String, password: String)
    case register(username: String, email: String, password: String)
    case deleteUser(id: Int)
    case updateUser(id: Int, userData: [String: Any])
    case isUsernameAvailable(username: String)
    case isEmailAvailable(email: String)
    
    case loginWithPhone(phone: String, captcha: String)
    
}

extension AuthAPI: TargetType {
    
    var baseURL: URL {
        return API.baseURL
    }
    
    var path: String {
        switch self {
        case .getUsers:
            return "/users"
        case .getUser(let id):
            return "/users/\(id)"
        case .register:
            return "/api/users/register"
        case .login:
            return "/api/users/login"
        case .isUsernameAvailable:
            return "/api/users/check-username"
        case .isEmailAvailable:
            return "/api/users/check-email"
        case .deleteUser(let id):
            return "/api/users/\(id)"
        case .updateUser(let id, _):
            return "/api/users/\(id)"
        case .loginWithPhone:
            return "/api/users/loginWithPhone"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUsers, .getUser:
            return .get
        case .register, .login, .isUsernameAvailable, .isEmailAvailable, .loginWithPhone:
            return .post
        case .deleteUser:
            return .delete
        case .updateUser:
            return .put
        }
    }
    
    //请求参数
    var task: Task {
        switch self {
            case .getUsers(let page):
                return .requestParameters(parameters: ["page": page], encoding: URLEncoding.default)
            case .getUser, .deleteUser:
                return .requestPlain
            case .register(let username, let email, let password):
                return .requestParameters(parameters:
                                            ["username" : username, "email": email, "password": password],
                                      encoding: JSONEncoding.default)
            
            case .isUsernameAvailable(let username):
                return .requestParameters(parameters: ["username" : username], encoding: JSONEncoding.default)
            
            case .isEmailAvailable(let email):
                return .requestParameters(parameters: ["email" : email], encoding: JSONEncoding.default)
            
            case .login(let username, let password):
                return .requestParameters(parameters: ["username": username, "password": password], encoding: JSONEncoding.default)
            
            case .updateUser(_, let userData):
                return .requestParameters(parameters: userData, encoding: JSONEncoding.default)
            
            case .loginWithPhone(let phone, let captcha):
                return .requestParameters(parameters: ["phone": phone, "captcha": captcha], encoding: JSONEncoding.default)
        }
    }
    
    //请求头
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    // 测试数据
    var sampleData: Data {
        return Data()
    }
}


// MARK: - 空数据模型
struct EmptyData: Codable {}

// MARK: - 用户模型
struct User: Codable {
    let userId: Int
    let username: String
    let email: String?
    let avatarUrl: String?
    let token: String?
}

// MARK: - 登录响应数据模型
struct LoginData: Codable {
    let userId: Int
    let username: String
    let email: String?
    let token: String
    let avatarUrl: String?
}

// MARK: - 注册响应数据模型
struct RegisterData: Codable {
    let userId: Int
    let username: String
    let email: String
}

// MARK: - 用户列表数据模型
struct UserListData: Codable {
    let users: [User]
    let total: Int
    let page: Int
}

// MARK: - 用户名或邮箱是否可注册
struct IsAvailableData: Codable {
    let available: Bool
}



// MARK: - 网络服务
class AuthService {
    let provider: MoyaProvider<AuthAPI>
    
    init() {
        let logger = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
        provider = MoyaProvider<AuthAPI>(plugins: [logger])
    }
    
    // 通用请求方法
    private func request<T: Codable>(_ target: AuthAPI, type: T.Type) -> Single<BaseResponse<T>> {
        return provider.rx.request(target)
            .do(onSuccess: { response in
                print("=== 网络响应调试 ===")
                print("状态码: \(response.statusCode)")
                print("🌏响应数据: \(String(data: response.data, encoding: .utf8) ?? "无法解析")")
                print("==================")
            }, onError: {error in
                print("=== 网络错误调试 ===")
                print(error.localizedDescription)
                if let moyaError = error as? MoyaError {
                    switch moyaError {
                    case .statusCode(let response):
                        print("🌏HTTP错误: \(response.statusCode)")
                    case .underlying(let underlyingError, _):
                        print("🌏底层错误: \(underlyingError)")
                    default:
                        print("其他 MoyaError 类型: \(moyaError)")
                    }
                }
                print("==================")
            })
            .flatMap { response -> Single<BaseResponse<T>> in
                //统一处理所有响应
                let statusCode = response.statusCode
                //检查Http状态码
                guard (200...299).contains(statusCode) else {
                    // 非2xx状态码抛出包含完整响应的错误
                    let responseBody = String(data: response.data, encoding: .utf8) ?? "无响应体"
                    let detail = "HTTP错误 \(statusCode): \(responseBody)"
                    throw AppError.serverError(statusCode: statusCode, detail: detail)
                }
                //尝试解码业务响应
                do {
                    let baseResponse =  try response.map(BaseResponse<T>.self)
                    return .just(baseResponse)
                } catch {
                    //解码失败，抛出解析错误
                    let responseBody = String(data: response.data, encoding: .utf8) ?? "无法解析"
                    let detail = "解析错误: \(error)\n原始响应: \(responseBody)"
                    throw AppError.decodingError.withDetail(detail)
                }
            }
            .catchError { error -> Single<BaseResponse<T>> in
                //处理 Moya 底层错误
                if let moyaError = error as? MoyaError {
                    switch moyaError {
                    case .statusCode(let response):
                        // 这里应该不会执行，因为上面已经处理了所有状态码
                        let statusCode = response.statusCode
                        let responseBody = String(data: response.data, encoding: .utf8) ?? "无响应体"
                        let detail = "Moya HTTP错误 \(statusCode): \(responseBody)"
                        return .error(AppError.serverError(statusCode: statusCode, detail: detail))
                        
                    case .underlying(let underlyingError, _):
                        let detail = "底层错误: \(underlyingError)"
                        return .error(AppError.networkError.withDetail(detail))
                        
                    case .objectMapping(let decodingError, let response):
                        let responseBody = String(data: response.data, encoding: .utf8) ?? "无法解析"
                        let detail = "对象映射错误: \(decodingError)\n原始响应: \(responseBody)"
                        return .error(AppError.decodingError.withDetail(detail))
                        
                    default:
                        let detail = "Moya未知错误: \(moyaError)"
                        return .error(AppError.networkError.withDetail(detail))
                    
                    }
                }
                // 如果不是 MoyaError，而是我们之前抛出的 AppError，直接传递
                if let networkError = error as? AppError {
                    return .error(networkError)
                }
                //其他未知错误
                let detail = "未处理错误: \(error)"
                return .error(AppError.networkError.withDetail(detail))
            }
    }
    
    // 登录 - 返回 LoginData
    func login(username: String, password: String) -> Single<BaseResponse<LoginData>> {
        return request(.login(username: username, password: password), type: LoginData.self)
            .extractBaseResponse()
    }
    
    // 登录 - 返回 LoginData
    func loginGetData(username: String, password: String) -> Single<LoginData> {
        return request(.login(username: username, password: password), type: LoginData.self)
            .extractData()
    }
    
    // 注册 - 返回 RegisterData
    func register(username: String, email: String, password: String) -> Single<RegisterData> {
        return request(.register(username: username, email: email, password: password), type: RegisterData.self)
            .extractData()
    }
    
    // 判断用户名是否被注册 - 返回 isValidData
    func isUsernameAvailable(username: String) ->Single<IsAvailableData> {
        return request(.isUsernameAvailable(username: username), type: IsAvailableData.self)
            .extractData()
    }
    
    // 判断邮箱是否被注册 - 返回 isValidData
    func isEmailAvailable(email: String) ->Single<IsAvailableData> {
        return request(.isEmailAvailable(email: email), type: IsAvailableData.self)
            .extractData()
    }
    
    // 获取用户列表 - 返回 UserListData
    func getUsers(page: Int = 1) -> Single<UserListData> {
        return request(.getUsers(page: page), type: UserListData.self)
            .extractData()
    }
    
    // 获取单个用户 - 返回 User
    func getUser(id: Int) -> Single<User> {
        return request(.getUser(id: id), type: User.self)
            .extractData()
    }
    
    // 删除用户 - 返回空数据
    func deleteUser(id: Int) -> Single<EmptyData> {
        return request(.deleteUser(id: id), type: EmptyData.self)
            .extractData()
    }
    
    // 更新用户信息 - 返回 User
    func updateUser(id: Int, userData: [String: Any]) -> Single<User> {
        return request(.updateUser(id: id, userData: userData), type: User.self)
            .extractData()
    }
    
    //手机号登录 - 返回User
    func loginWithPhone(phone: String, captcha: String) -> Single<User> {
        return request(.loginWithPhone(phone: phone, captcha: captcha), type: User.self)
            .extractData()
    }
    
}

// MARK: - 错误处理
enum AuthError: Error {
    case invalidCredentials
    case emailAlreadyExists
    case validationFailed([String: [String]])
    case serverError
    case networkError
    case decodingError
    case apiError(String)
    
    var description: String {
        switch self {
        case .invalidCredentials:
            return "邮箱或密码不正确"
        case .emailAlreadyExists:
            return "该邮箱已被注册"
        case .validationFailed(let errors):
            return errors.values.flatMap { $0 }.joined(separator: "\n")
        case .serverError:
            return "服务器错误，请稍后再试"
        case .networkError:
            return "网络连接失败"
        case .decodingError:
            return "数据解析失败"
        case .apiError(let message):
            return message
        }
    }
}


// 定义错误类型
enum NetworkError: Error {
    case serverError(response: Response)  // 包含原始响应
    case decodingError(response: Response, underlyingError: Error)
    case connectionError(Error)
    case unknownError
    
    // 错误描述
    var localizedDescription: String {
        switch self {
        case .serverError(let response):
            return "服务器错误 (\(response.statusCode))"
        case .decodingError(_, let error):
            return "数据解析失败: \(error.localizedDescription)"
        case .connectionError(let error):
            return "网络连接错误: \(error.localizedDescription)"
        case .unknownError:
            return "未知错误"
        }
    }
    
    // 原始响应数据
    var responseData: Data? {
        switch self {
        case .serverError(let response), .decodingError(let response, _):
            return response.data
        default:
            return nil
        }
    }
    
    // HTTP 状态码
    var statusCode: Int? {
        switch self {
        case .serverError(let response):
            return response.statusCode
        default:
            return nil
        }
    }
}

// MARK: - 定义业务错误类型
enum BusinessError: Error {
    case apiError(statusCode: Int, message: String)
    
    var localizedDescription: String {
        switch self {
            case .apiError(let statusCode, let message):
                return "业务错误 [\(statusCode)]: \(message)"
        }
    }
}

// MARK: - Single 扩展
//返回 data段
extension PrimitiveSequence where Trait == SingleTrait {
    // 从 BaseResponse 中提取 data
    func extractData<T>() -> Single<T> where Element == BaseResponse<T> {
        return self.map { baseResponse in
            guard let data = baseResponse.data else {
                throw BusinessError.apiError(
                    statusCode: baseResponse.statusCode,
                    message: baseResponse.message
                )
            }
            return data
        }
    }
}

//返回 整个 BaseResponse
extension PrimitiveSequence where Trait == SingleTrait {
    func extractBaseResponse<T>() -> Single<BaseResponse<T>> where Element == BaseResponse<T> {
        return self // 直接返回，不做 data 提取
    }
}
