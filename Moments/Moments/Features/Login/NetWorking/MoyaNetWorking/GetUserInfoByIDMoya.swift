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

// MARK: - Single 扩展
extension PrimitiveSequence where Trait == SingleTrait {
    // 从 BaseResponse 中提取 data
    func extractData<T>() -> Single<T> where Element == BaseResponse<T> {
        return self.map { baseResponse in
            // 检查状态码
            guard baseResponse.statusCode == 200 else {
                throw AuthError.apiError(baseResponse.message)
            }
            return baseResponse.data
        }
    }
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
            .filterSuccessfulStatusCodes()
            .do(onSuccess: { response in
                print("=== 网络响应调试 ===")
                print("状态码: \(response.statusCode)")
                print("响应数据: \(String(data: response.data, encoding: .utf8) ?? "无法解析")")
                print("==================")
            })
            .map(BaseResponse<T>.self)
            .catchError { error in
                print("=== 网络错误调试 ===")
//                print("错误类型: \(String(describing: type(of: error)))")
                print("错误描述: \(error)")
                print("错误详情: \(error.localizedDescription)")
                
                guard let moyaError = error as? MoyaError else {
                    return .error(error)
                }
                
                switch moyaError {
                case .statusCode(let response):
                    print("HTTP状态码: \(response.statusCode)")
                    if response.statusCode == 401 {
                        return .error(AuthError.invalidCredentials)
                    } else if response.statusCode == 422 {
                        do {
                            let errors = try response.map([String: [String]].self)
                            return .error(AuthError.validationFailed(errors))
                        } catch {
                            return .error(AuthError.decodingError)
                        }
                    } else if response.statusCode == 409 {
                        return .error(AuthError.emailAlreadyExists)
                    } else {
                        return .error(AuthError.serverError)
                    }
                case .underlying(let underlyingError, _):
                    print("底层错误: \(underlyingError)")
                    return .error(AuthError.networkError)
                case .objectMapping(let decodingError, let response):
                    print("对象映射错误: \(decodingError)")
                    print("响应数据: \(String(data: response.data, encoding: .utf8) ?? "无法解析")")
                    return .error(AuthError.decodingError)
                default:
                    print("其他 MoyaError 类型")
                    return .error(error)
                }
            }
    }
    
    // 登录 - 返回 LoginData
    func login(username: String, password: String) -> Single<LoginData> {
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
