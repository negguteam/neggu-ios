//
//  APIError.swift
//  neggu
//
//  Created by 유지호 on 8/4/24.
//

import Foundation

public enum APIError: Error, Equatable {
    case client(statusCode: Int, message: String)
    case server(statusCode: Int, message: String)
    case unknown
    
    init(statusCode: Int, message: String) {
        switch statusCode {
        case 400..<500: self = .client(statusCode: statusCode, message: message)
        case ..<600: self = .server(statusCode: statusCode, message: message)
        default: self = .unknown
        }
    }
}

public enum ErrorType: CaseIterable, Equatable {
    case notFoundImage
    case imageUploadFail
    
    case unauthorized
    case tokenExpired
    case invalidJwtToken
    case invalidIdToken
    case invalidRefreshToken
    case duplicateUserLogin
    
    case notFoundUser
    case duplicateNickname
  
    case notFoundClothes
    case notFoundLookBook
    case notFoundInvite
    
    case unknown
    
    public var code: Int {
        switch self {
        case .unauthorized, .tokenExpired, .invalidJwtToken, .invalidIdToken, .invalidRefreshToken, .duplicateUserLogin:
            401
        case .notFoundImage, .notFoundUser, .duplicateNickname, .notFoundClothes, .notFoundLookBook, .notFoundInvite:
            404
        case .imageUploadFail:
            500
        case .unknown:
            -1
        }
    }
    
    public var description: String {
        switch self {
        case .notFoundImage: "존재하지 않는 이미지입니다."
        case .imageUploadFail: "이미지 업로드에 실패했습니다."
            
        case .unauthorized: "인증되지 않은 사용자입니다."
        case .tokenExpired: "토큰이 만료되었습니다."
        case .invalidJwtToken: "유효하지 않은 토큰입니다."
        case .invalidIdToken: "유효하지 않은 ID TOKEN입니다."
        case .invalidRefreshToken: "유효하지 않은 RefreshToken입니다."
        case .duplicateUserLogin: "중복된 로그인이 감지되었습니다."
            
        case .notFoundUser: "존재하지 않은 사용자입니다."
        case .duplicateNickname: "중복된 닉네임입니다."
            
        case .notFoundClothes: "존재하지 않는 옷입니다."
        case .notFoundLookBook: "존재하지 않는 룩북입니다."
        case .notFoundInvite: "존재하지 않는 초대코드입니다."
            
        case .unknown: "알 수 없는 에러입니다."
        }
    }
    
    public init(code: Int, message: String) {
        self = ErrorType.allCases.first(where: { ($0.code, $0.description) == (code, message)
        }) ?? .unknown
    }
}
