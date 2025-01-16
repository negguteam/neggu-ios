//
//  ClosetAPI.swift
//  neggu
//
//  Created by 유지호 on 1/16/25.
//

import Foundation
import Moya

enum ClosetAPI {
    case register(image: Data, parameters: [String: Any])
    case clothesDetail(id: String)
    case clothesList(page: Int, size: Int)
    case brandList
    case deleteClothes(id: String)
}

extension ClosetAPI: BaseAPI {
    
    static var apiType: APIType = .closet
    
    var path: String {
        switch self {
        case .register:
            ""
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
        case .register: .post
        case .deleteClothes: .delete
        default: .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .register(let image, let parameters):
            let bodyData = (try? JSONSerialization.data(withJSONObject: parameters)) ?? .init()
            return .uploadMultipart([
                MultipartFormData(provider: .data(image), name: "image", mimeType: "image/png"),
                MultipartFormData(provider: .data(bodyData), name: "clothRegisterRequest")
            ])
        case .clothesList(let page, let size):
            return .requestParameters(
                parameters: ["page": page, "size": size],
                encoding: URLEncoding.queryString
            )
        default:
            return .requestPlain
        }
    }
    
}
