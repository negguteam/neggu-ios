//
//  Clothes.swift
//  neggu
//
//  Created by 유지호 on 9/6/24.
//

//import Foundation
import SwiftUI

enum PriceRange: String, CaseIterable {
    case unknown = "잘 모르겠어요"
    case first = "~5만원"
    case second = "5~10만원"
    case third = "10~20만"
    
    static var allCasesArray: [Self] {
        allCases.filter { $0 != .unknown }
    }
    
    init(from decoder: Decoder) throws {
        self = try PriceRange(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}

enum Gender: String, CaseIterable, Identifiable {
    case male = "남성"
    case female = "여성"
    case unknown
    
    var id: String { "\(self)" }
    
    static var allCasesArray: [Self] {
        allCases.filter { $0 != .unknown }
    }
    
    init(from decoder: Decoder) throws {
        self = try Gender(rawValue: decoder.singleValueContainer().decode(RawValue.self).lowercased()) ?? .unknown
    }
}

enum Mood: String, CaseIterable, Identifiable {
    case feminine = "페미닌"
    case sports = "스포츠"
    case streetWear = "스트릿"
    case modern = "모던"
    case vintage = "빈티지"
    case outdoor = "아웃도어"
    case office = "오피스"
    case ethnic = "에스닉"
    case preppy = "프레피"
    case luxury = "럭셔리"
    case casual = "캐주얼"
    case american = "아메리칸"
    case unknown
    
    var id: String { "\(self)" }
    
    static var allCasesArray: [Self] {
        allCases.filter { $0 != .unknown }
    }
    
    init(from decoder: Decoder) throws {
        self = try Mood(rawValue: decoder.singleValueContainer().decode(RawValue.self).lowercased()) ?? .unknown
    }
}

enum Category: String, CaseIterable {
    case top = "상의"
    case outer = "아우터"
    case bottom = "하의"
    case unknown = ""
    
    init(from decoder: Decoder) throws {
        self = try Category(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
    
    static var allCasesArray: [Self] {
        allCases.filter { $0 != .unknown }
    }
}

enum SubCategory: String, CaseIterable {
    case sweatShirt = "맨투맨"
    case shirtBlouse = "셔츠/블라우스"
    case hoodie = "후드"
    case knit = "니트"
    case tShirt = "티셔츠"
    case sleeveless = "민소매"
    
    case jacket = "자켓"
    case zipUpHoodie = "후드집업"
    case cardigan = "가디건"
    case fleece = "플리스"
    case coat = "코트"
    case puffer = "패딩"
    case vest = "베스트"
    
    case jeans = "데님팬츠"
    case slacks = "슬랙스"
    case shorts = "솟팬츠"
    case jumpsuit = "점프슈트"
    case skirt = "스커트"
    
    case unknown = ""
    
    init(from decoder: Decoder) throws {
        self = try SubCategory(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
    
    static var allCasesArray: [Self] {
        allCases.filter { $0 != .unknown }
    }
}


protocol Clothesable: Decodable {
    func toProduct(urlString: String) -> Clothes
}

struct ClothesEntity: Codable {
    let id: String
    var sku: String?
    let name: String
    var account: String?
    let link: String
    let imageUrl: String
    var category: String?
    var subCategory: String?
    var mood: String?
    let brand: String
    var priceRange: String?
    var colorCode: String?
    let memo: String
    let isPurchase: Bool
}

struct Clothes: Equatable, Hashable, Identifiable {
    let id: String = UUID().uuidString
    var sku: String?
    var name: String
    var account: String?
    var link: String
    let imageUrl: String
    var category: Category = .unknown
    var subCategory: SubCategory = .unknown
    var mood: Mood = .unknown
    var brand: String
    var priceRange: PriceRange = .unknown
    var colorCode: String?
    var memo: String = ""
    var isPurchase: Bool = false
    
    var offset: CGSize = .zero
    var lastOffset: CGSize = .zero
    var scale: CGFloat = 1.0
    var lastScale: CGFloat = 1.0
    var angle: Angle = .degrees(0)
    var lastAngle: Angle = .degrees(0)
}


struct AblyProduct: Clothesable {
    var props: Props
    
    struct Props: Decodable {
        var serverQueryClient: QueryClient
        
        struct QueryClient: Decodable {
            var queries: [Query]
            
            struct Query: Decodable {
                var state: State
                
                struct State: Decodable {
                    var data: StateData
                    
                    struct StateData: Decodable {
                        var goods: Good
                        
                        struct Good: Decodable {
                            var name: String
                            var image: String
                            var price: Int
                            var market: Market
                            
                            struct Market: Decodable {
                                var name: String
                            }
                        }
                    }
                }
            }
        }
    }
    
    func toProduct(urlString: String) -> Clothes {
        let goods = props.serverQueryClient.queries[0].state.data.goods
        return .init(
            name: goods.name,
            link: urlString,
            imageUrl: goods.image,
            brand: goods.market.name
        )
    }
}

struct MusinsaProduct: Clothesable {
    var name: String
    var image: String
    var brand: Brand
    var offers: Offers
    var aggregateRating: AggregateRating
    
    struct Brand: Decodable {
        var name: String
    }
    
    struct Offers: Decodable {
        var price: String
        var priceCurrency: String
    }
    
    struct AggregateRating: Decodable {
        var ratingValue: String
        var reviewCount: String
    }
    
    func toProduct(urlString: String) -> Clothes {
        return .init(
            name: self.name,
            link: urlString,
            imageUrl: image,
            brand: brand.name
        )
//        return .init(
//            link: urlString,
//            name: name,
//            imageUrl: image,
//            brand: brand.name,
//            price: Int(offers.price) ?? 0
//        )
    }
}

struct ZigzagProduct: Clothesable {
    var name: String
    var description: String
    var image: [String]
    var brand: Brand
    var offers: [Offers]
    
    struct Brand: Decodable {
        var name: String
    }
    
    struct Offers: Decodable {
        var price: Int
        var priceCurrency: String
    }
    
    func toProduct(urlString: String) -> Clothes {
        return .init(
            name: name,
            link: urlString,
            imageUrl: image[0],
            brand: brand.name
        )
    }
}

struct QueenitProduct: Clothesable {
    var props: Props
    
    struct Props: Decodable {
        var pageProps: PageProps
        
        struct PageProps: Decodable {
            var dehydratedState: DehydratedState
            
            struct DehydratedState: Decodable {
                var queries: [Query]
                
                struct Query: Decodable {
                    var state: State
                    
                    struct State: Decodable {
                        var data: StateData
                        
                        struct StateData: Decodable {
                            var product: Product
                            
                            struct Product: Decodable {
                                var productId: String
                                var imageUrl: String
                                var name: String
                                var originalPrice: Int
                                var brand: String
                            }
                        }
                    }
                }
            }
        }
    }
    
    func toProduct(urlString: String) -> Clothes {
        let goods = props.pageProps.dehydratedState.queries[0].state.data.product
        
        return .init(
            name: goods.name,
            link: urlString,
            imageUrl: goods.imageUrl,
            brand: goods.brand
        )
    }
}

struct TwentyNineCMProduct: Clothesable {
    var props: Props
    
    struct Props: Decodable {
        var pageProps: PageProps
        
        struct PageProps: Decodable {
            var dehydratedState: DehydratedState
            
            struct DehydratedState: Decodable {
                var queries: [Query]
                
                struct Query: Decodable {
                    var state: State
                    
                    struct State: Decodable {
                        var data: StateData
                        
                        struct StateData: Decodable {
                            var itemNo: Int
                            var itemName: String
                            var sellPrice: Int
                            var itemImages: [ItemImage]
                            var frontBrand: FrontBrand
                            
                            struct ItemImage: Decodable {
                                var imageUrl: String
                            }
                            
                            struct FrontBrand: Decodable {
                                var brandNameEng: String
                                var brandNameKor: String
                            }
                        }
                    }
                }
            }
        }
    }
    func toProduct(urlString: String) -> Clothes {
        let goods = props.pageProps.dehydratedState.queries[0].state.data
        
        return .init(
            name: goods.itemName,
            link: urlString,
            imageUrl: "https://img.29cm.co.kr" + goods.itemImages[0].imageUrl,
            brand: goods.frontBrand.brandNameKor
        )
    }
}

struct KreamProduct: Clothesable {
    var name: String
    var description: String
    var image: [String]
    var sku: String
    var brand: Brand
    var offers: Offers
    
    struct Brand: Decodable {
        var name: String
    }
    
    struct Offers: Decodable {
        var url: String
        var price: Int
        var lowPrice: Int
        var highPrice: Int
        var priceCurrency: String
    }
    
    func toProduct(urlString: String) -> Clothes {
        return .init(
            name: name,
            link: urlString,
            imageUrl: image[0],
            brand: brand.name
        )
    }
}
