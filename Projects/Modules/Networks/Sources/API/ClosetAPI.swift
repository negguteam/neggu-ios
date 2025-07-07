//
//  ClosetAPI.swift
//  neggu
//
//  Created by 유지호 on 1/16/25.
//

import Foundation
import Moya

public enum ClosetAPI {
    case register(image: Data, request: Data)
    case modify(paramters: [String: Any])
    case clothesDetail(id: String)
    case clothesList(parameters: [String: Any])
    case clothesInviteList(parameters: [String: Any])
    case brandList
    case deleteClothes(id: String)
}

extension ClosetAPI: BaseAPI {
    
    public static var apiType: APIType = .closet
    
    public var path: String {
        switch self {
        case .register:
            ""
        case .modify:
            "/modify"
        case .clothesDetail(let id):
            "/\(id)"
        case .clothesList:
            "/page"
        case .clothesInviteList:
            "/invite"
        case .brandList:
            "/brands"
        case .deleteClothes(let id):
            "/\(id)"
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .register:
            HeaderType.multipartWithToken.value
        default:
            HeaderType.jsonWithToken.value
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .register, .modify: .post
        case .deleteClothes: .delete
        default: .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .register(let image, let request):
            var multipartData: [MultipartFormData] = []
            multipartData.append(.init(provider: .data(image), name: "image", fileName: "clothesImage", mimeType: "image/png"))
            multipartData.append(.init(provider: .data(request), name: "clothRegisterRequest"))
            
            return .uploadMultipart(multipartData)
        case .modify(let paramters):
            return .requestParameters(
                parameters: paramters,
                encoding: JSONEncoding.default
            )
        case .clothesList(let parameters), .clothesInviteList(let parameters):
            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.queryString
            )
        default:
            return .requestPlain
        }
    }
    
}
