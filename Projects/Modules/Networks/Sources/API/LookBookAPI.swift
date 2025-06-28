//
//  LookBookAPI.swift
//  neggu
//
//  Created by 유지호 on 2/14/25.
//

import Foundation
import Moya

public enum LookBookAPI {
    case register(image: Data, request: Data)
    case registerByInvite(image: Data, request: Data)
    case negguInvite
    case lookbookDetail(id: String)
    case lookbookList(parameters: [String: Any])
    case lookbookClothes(parameters: [String: Any])
    case modifyDate(id: String, targetDate: String)
    case deleteLookBook(id: String)
}

extension LookBookAPI: BaseAPI {
    
    public static var apiType: APIType = .lookbook
    
    public var path: String {
        switch self {
        case .register:
            ""
        case .registerByInvite:
            "/invite"
        case .negguInvite:
            "/generate/invite"
        case .lookbookDetail(let id):
            "/\(id)"
        case .lookbookList:
            "/page"
        case .lookbookClothes:
            "/cloth/page"
        case .modifyDate:
            "/date"
        case .deleteLookBook(let id):
            "/\(id)"
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .register, .registerByInvite:
            HeaderType.multipartWithToken.value
        default:
            HeaderType.jsonWithToken.value
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .lookbookDetail, .lookbookList, .lookbookClothes: .get
        case .deleteLookBook: .delete
        default: .post
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .register(let image, let request):
            var multipartData: [MultipartFormData] = []
            multipartData.append(.init(provider: .data(image), name: "image", fileName: "lookBookImage", mimeType: "image/png"))
            multipartData.append(.init(provider: .data(request), name: "lookBookRequest"))
            
            return .uploadMultipart(multipartData)
        case .registerByInvite(let image, let request):
            var multipartData: [MultipartFormData] = []
            multipartData.append(.init(provider: .data(image), name: "image", fileName: "lookBookImage", mimeType: "image/png"))
            multipartData.append(.init(provider: .data(request), name: "lookBookByInviteRequest"))
            
            return .uploadMultipart(multipartData)
        case .lookbookList(let parameters), .lookbookClothes(let parameters):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .modifyDate(let id, let targetDate):
            return .requestParameters(
                parameters: ["lookBookId": id,
                             "lookBookTargetDateRequest": "{\"targetDate\": \"\(targetDate)\"}"],
                encoding: URLEncoding.queryString
            )
        default:
            return .requestPlain
        }
    }
    
}

