//
//  ClosetAPI.swift
//  neggu
//
//  Created by 유지호 on 1/16/25.
//

import Foundation
import Moya

enum ClosetAPI {
    case register(image: Data, request: Data)
    case modify(paramters: [String: Any])
    case clothesDetail(id: String)
    case clothesList(parameters: [String: Any])
    case brandList
    case deleteClothes(id: String)
}

extension ClosetAPI: BaseAPI {
    
    static var apiType: APIType = .closet
    
    var path: String {
        switch self {
        case .register:
            ""
        case .modify:
            "/modify"
        case .clothesDetail(let id):
            "/\(id)"
        case .clothesList:
            "/page"
        case .brandList:
            "/brands"
        case .deleteClothes(let id):
            "/\(id)"
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .register:
            HeaderType.multipartWithToken.value
        default:
            HeaderType.jsonWithToken.value
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .register, .modify: .post
        case .deleteClothes: .delete
        default: .get
        }
    }
    
    var task: Moya.Task {
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
        case .clothesList(let parameters):
            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.queryString
            )
        default:
            return .requestPlain
        }
    }
    
}
