//
//  NegguInterceptor.swift
//  neggu
//
//  Created by 유지호 on 8/4/24.
//

import Foundation
import Alamofire

class NegguInterceptor: RequestInterceptor {
    
    public typealias AdapterResult = Result<URLRequest, Error>
    private let authService = DefaultAuthService()
    
    public func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var adaptedRequest = urlRequest
        validateHeader(&adaptedRequest)
        completion(.success(adaptedRequest))
    }
    
    // Note: 토큰 재발급 시 AccessToken 갱신
    private func validateHeader(_ urlRequest: inout URLRequest) {
        if urlRequest.url?.absoluteString.last == "/" {
            var urlString = urlRequest.url?.absoluteString
            urlString?.removeLast()
            urlRequest.url = URL(string: urlString ?? "")
        }
        
        let headers = urlRequest.headers.map {
            guard $0.name == "Authorization" else { return $0 }
            return HTTPHeader(
                name: $0.name,
                value: "Bearer \(UserDefaultsKey.Auth.accessToken ?? "none")"
            )
        }
        
        urlRequest.headers = HTTPHeaders(headers)
    }
    
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: any Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        guard let response = request.response,
              let pathComponents = request.request?.url?.pathComponents,
              !pathComponents.contains("token")
        else {
            DispatchQueue.main.async {
                AlertManager.shared.setAlert(message: error.localizedDescription)
            }
            
            completion(.retryWithDelay(10))
            return
        }
        
        switch response.statusCode {
        case 401:
            authService.tokenReissuance { isSuccessed in
                if isSuccessed {
                    completion(.retry)
                } else {
                    DispatchQueue.main.async {
                        AlertManager.shared.setAlert(
                            title: "안내",
                            message: "토큰이 만료되었습니다. 다시 로그인 해주세요."
                        ) {
                            UserDefaultsKey.clearUserData()
                            UserDefaultsKey.Auth.isLogined = false
                        }
                    }
                    
                    completion(.doNotRetry)
                }
            }
        default:
            completion(.doNotRetryWithError(error))
        }
    }
    
}
