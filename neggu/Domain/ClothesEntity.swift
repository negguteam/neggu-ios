//
//  Clothes.swift
//  neggu
//
//  Created by 유지호 on 9/6/24.
//

import Foundation

struct ClosetEntity: Decodable {
    let totalElements: Int
    let totalPages: Int
    let size: Int
    let content: [ClothesEntity]
    let number: Int
    let numberOfElements: Int
    let first: Bool
    let last: Bool
    let empty: Bool
}

struct ClothesRegisterEntity: Codable, Equatable, Hashable {
    var name: String
    var colorCode: String?
    var category: Category = .UNKNOWN
    var subCategory: SubCategory = .UNKNOWN
    var mood: [Mood] = []
    var brand: String
    var priceRange: PriceRange = .UNKNOWN
    var memo: String = ""
    var isPurchase: Bool = false
    var link: String
    
    static var mockData: Self {
        return .init(name: "멋진 옷", brand: "Neggu", link: "www.neggu.com")
    }
    
    static var emptyData: Self {
        return .init(name: "", brand: "", link: "")
    }
}

struct ClothesEntity: Decodable, Identifiable, Equatable, Hashable {
    let id: String
    let accountId: String
    let clothId: String
    let name: String
    let link: String
    let imageUrl: String
    let category: Category
    let subCategory: SubCategory
    let mood: [Mood]
    let brand: String
    let priceRange: PriceRange
    let memo: String
    var color: String
    var colorCode: String
    let isPurchase: Bool
    let createdAt: String
    let modifiedAt: String
}



protocol Clothesable: Decodable {
    var imageUrl: String { get }
    
    func toProduct(urlString: String) -> ClothesRegisterEntity
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
    
    var imageUrl: String {
        props.serverQueryClient.queries[0].state.data.goods.image
    }
    
    func toProduct(urlString: String) -> ClothesRegisterEntity {
        let goods = props.serverQueryClient.queries[0].state.data.goods
        return .init(
            name: goods.name,
            brand: goods.market.name,
            link: urlString
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
    
    var imageUrl: String {
        "https://image.msscdn.net/thumbnails" + props.pageProps.meta.data.thumbnailImageUrl
    }
    
    func toProduct(urlString: String) -> ClothesRegisterEntity {
        let product = props.pageProps.meta.data
        
        return .init(
            name: product.goodsNm,
            brand: product.brand,
            link: urlString
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
    
    var imageUrl: String {
        props.pageProps.product.imageList[0].url
    }
    
    func toProduct(urlString: String) -> ClothesRegisterEntity {
        let product = props.pageProps.product
        
        return .init(
            name: product.name,
            brand: product.brand,
            link: urlString
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
    
    var imageUrl: String {
        props.pageProps.dehydratedState.queries[0].state.data.product.imageUrl
    }
    
    func toProduct(urlString: String) -> ClothesRegisterEntity {
        let product = props.pageProps.dehydratedState.queries[0].state.data.product
        
        return .init(
            name: product.name,
            brand: product.brand,
            link: urlString
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
    
    var imageUrl: String {
        "https://img.29cm.co.kr" + props.pageProps.dehydratedState.queries[0].state.data.itemImages[0].imageUrl
    }
    
    func toProduct(urlString: String) -> ClothesRegisterEntity {
        let goods = props.pageProps.dehydratedState.queries[0].state.data
        
        return .init(
            name: goods.itemName,
            brand: goods.frontBrand.brandNameKor,
            link: urlString
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
    
    var imageUrl: String {
        image[0]
    }
    
    func toProduct(urlString: String) -> ClothesRegisterEntity {
        return .init(
            name: name,
            brand: brand.name,
            link: urlString
        )
    }
}
