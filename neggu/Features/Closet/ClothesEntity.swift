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

enum Category: String, CaseIterable, Identifiable {
    case top = "상의"
    case outer = "아우터"
    case bottom = "하의"
    case unknown = ""
    
    var id: String { "\(self)" }
    
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
    let props: Props
    
    struct Props: Decodable {
        let serverQueryClient: QueryClient
        
        struct QueryClient: Decodable {
            let queries: [Query]
            
            struct Query: Decodable {
                let state: State
                
                struct State: Decodable {
                    let data: StateData
                    
                    struct StateData: Decodable {
                        let goods: Good
                        
                        struct Good: Decodable {
                            let name: String
                            let image: String
                            let price: Int
                            let market: Market
                            
                            struct Market: Decodable {
                                let name: String
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
    let props: Props
    
    struct Props: Decodable {
        let pageProps: PageProps
        
        struct PageProps: Decodable {
            let meta: Meta
            
            struct Meta: Decodable {
                let data: ProductData
                
                struct ProductData: Decodable {
                    let goodsNo: Int
                    let goodsNm: String
                    let goodsNmEng: String
                    let thumbnailImageUrl: String
                    let brand: String
                    let category: Category
                    
                    struct Category: Decodable {
                        let categoryDepth1Title: String
                    }
                    
                    struct Price: Decodable {
                        let originPrice: Int
                    }
                }
            }
        }
    }
    
    func toProduct(urlString: String) -> Clothes {
        let product = props.pageProps.meta.data
        
        return .init(
            name: product.goodsNm,
            link: urlString,
            imageUrl: "https://image.msscdn.net/thumbnails" + product.thumbnailImageUrl,
            brand: product.brand
        )
    }
}

struct ZigzagProduct: Clothesable {
    let props: Props
    
    struct Props: Decodable {
        let pageProps: PageProps
        
        struct PageProps: Decodable{
            let product: Product
            
            struct Product: Decodable {
                let id: String
                let name: String
                let brand: String
                let productURL: String
                let description: String
                let imageList: [ProductImage]
                
                struct ProductImage: Decodable {
                    let url: String
                }
                
                enum CodingKeys: String, CodingKey {
                    case id, name, description
                    case brand = "shop_main_domain"
                    case productURL = "product_url"
                    case imageList = "product_image_list"
                }
            }
        }
    }
    
    func toProduct(urlString: String) -> Clothes {
        let product = props.pageProps.product
        
        return .init(
            name: product.name,
            link: urlString,
            imageUrl: product.imageList[0].url,
            brand: product.brand
        )
    }
}

struct QueenitProduct: Clothesable {
    let props: Props
    
    struct Props: Decodable {
        let pageProps: PageProps
        
        struct PageProps: Decodable {
            let dehydratedState: DehydratedState
            
            struct DehydratedState: Decodable {
                let queries: [Query]
                
                struct Query: Decodable {
                    let state: State
                    
                    struct State: Decodable {
                        let data: StateData
                        
                        struct StateData: Decodable {
                            let product: Product
                            
                            struct Product: Decodable {
                                let productId: String
                                let imageUrl: String
                                let name: String
                                let originalPrice: Int
                                let brand: String
                            }
                        }
                    }
                }
            }
        }
    }
    
    func toProduct(urlString: String) -> Clothes {
        let product = props.pageProps.dehydratedState.queries[0].state.data.product
        
        return .init(
            name: product.name,
            link: urlString,
            imageUrl: product.imageUrl,
            brand: product.brand
        )
    }
}

struct TwentyNineCMProduct: Clothesable {
    let props: Props
    
    struct Props: Decodable {
        let pageProps: PageProps
        
        struct PageProps: Decodable {
            let dehydratedState: DehydratedState
            
            struct DehydratedState: Decodable {
                let queries: [Query]
                
                struct Query: Decodable {
                    let state: State
                    
                    struct State: Decodable {
                        let data: StateData
                        
                        struct StateData: Decodable {
                            let itemNo: Int
                            let itemName: String
                            let sellPrice: Int
                            let itemImages: [ItemImage]
                            let frontBrand: FrontBrand
                            
                            struct ItemImage: Decodable {
                                let imageUrl: String
                            }
                            
                            struct FrontBrand: Decodable {
                                let brandNameEng: String
                                let brandNameKor: String
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
