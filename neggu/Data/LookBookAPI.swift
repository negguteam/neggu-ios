//
//  LookBookAPI.swift
//  neggu
//
//  Created by 유지호 on 2/14/25.
//

import Foundation
import Moya

enum LookBookAPI {
    case register(image: Data, request: Data)
    case lookbookDetail(id: String)
    case lookbookList(parameters: [String: Any])
    case lookbookClothes(parameters: [String: Any])
    case deleteLookBook(id: String)
}

extension LookBookAPI: BaseAPI {
    
    static var apiType: APIType = .lookbook
    
    var path: String {
        switch self {
        case .register:
            ""
        case .lookbookDetail(let id):
            "/\(id)"
        case .lookbookList:
            "/page"
        case .lookbookClothes:
            "/cloth/page"
        case .deleteLookBook(let id):
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
        case .deleteLookBook: .delete
        default: .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .register(let image, let request):
            var multipartData: [MultipartFormData] = []
            multipartData.append(.init(provider: .data(image), name: "image", fileName: "lookBookImage", mimeType: "image/png"))
            multipartData.append(.init(provider: .data(request), name: "lookBookRequest"))
            
            return .uploadMultipart(multipartData)
        case .lookbookList(let parameters), .lookbookClothes(let parameters):
            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.queryString
            )
        default:
            return .requestPlain
        }
    }
    
}

