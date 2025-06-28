//
//  Clothes.swift
//  neggu
//
//  Created by 유지호 on 9/6/24.
//

import Core

import Foundation

public struct ClosetEntity: Decodable {
    public let totalElements: Int
    public let totalPages: Int
    public let size: Int
    public let content: [ClothesEntity]
    public let number: Int
    public let numberOfElements: Int
    public let first: Bool
    public let last: Bool
    public let empty: Bool
}

public struct ClothesRegisterEntity: Codable, Equatable, Hashable {
    public var name: String
    public var colorCode: String?
    public var category: Core.Category = .UNKNOWN
    public var subCategory: SubCategory = .UNKNOWN
    public var mood: [Mood] = []
    public var brand: String
    public var priceRange: PriceRange = .UNKNOWN
    public var memo: String = ""
    public var isPurchase: Bool = false
    public var link: String
    
    public static var mockData: Self {
        return .init(name: "멋진 옷", brand: "Neggu", link: "www.neggu.com")
    }
    
    public static var emptyData: Self {
        return .init(name: "", brand: "", link: "")
    }
}

public struct ClothesEntity: Decodable, Identifiable, Equatable, Hashable {
    public let id: String
    public let accountId: String
    public let clothId: String
    public let name: String
    public let link: String
    public let imageUrl: String
    public let category: Core.Category
    public let subCategory: SubCategory
    public let mood: [Mood]
    public let brand: String
    public let priceRange: PriceRange
    public let memo: String
    public var color: String
    public var colorCode: String
    public let isPurchase: Bool
//    let createdAt: String
    public let modifiedAt: String
}



public protocol Clothesable: Decodable {
    var imageUrl: String { get }
    
    func toProduct(urlString: String) -> ClothesRegisterEntity
}

public struct AblyProduct: Clothesable {
    public let props: Props
    
    public struct Props: Decodable {
        public let serverQueryClient: QueryClient
        
        public struct QueryClient: Decodable {
            public let queries: [Query]
            
            public struct Query: Decodable {
                public let state: State
                
                public struct State: Decodable {
                    public let data: StateData
                    
                    public struct StateData: Decodable {
                        public let goods: Good
                        
                        public struct Good: Decodable {
                            public let name: String
                            public let image: String
                            public let price: Int
                            public let market: Market
                            
                            public struct Market: Decodable {
                                public let name: String
                            }
                        }
                    }
                }
            }
        }
    }
    
    public var imageUrl: String {
        props.serverQueryClient.queries[0].state.data.goods.image
    }
    
    public func toProduct(urlString: String) -> ClothesRegisterEntity {
        let goods = props.serverQueryClient.queries[0].state.data.goods
        return .init(
            name: goods.name,
            brand: goods.market.name,
            link: urlString
        )
    }
}

public struct MusinsaProduct: Clothesable {
    public let props: Props
    
    public struct Props: Decodable {
        public let pageProps: PageProps
        
        public struct PageProps: Decodable {
            public let meta: Meta
            
            public struct Meta: Decodable {
                public let data: ProductData
                
                public struct ProductData: Decodable {
                    public let goodsNo: Int
                    public let goodsNm: String
                    public let goodsNmEng: String
                    public let thumbnailImageUrl: String
                    public let brand: String
                    public let category: Category
                    
                    public struct Category: Decodable {
                        public let categoryDepth1Title: String
                    }
                    
                    public struct Price: Decodable {
                        public let originPrice: Int
                    }
                }
            }
        }
    }
    
    public var imageUrl: String {
        "https://image.msscdn.net/thumbnails" + props.pageProps.meta.data.thumbnailImageUrl
    }
    
    public func toProduct(urlString: String) -> ClothesRegisterEntity {
        let product = props.pageProps.meta.data
        
        return .init(
            name: product.goodsNm,
            brand: product.brand,
            link: urlString
        )
    }
}

public struct ZigzagProduct: Clothesable {
    public let props: Props
    
    public struct Props: Decodable {
        public let pageProps: PageProps
        
        public struct PageProps: Decodable{
            public let product: Product
            
            public struct Product: Decodable {
                public let id: String
                public let name: String
                public let brand: String
                public let productURL: String
                public let description: String
                public let imageList: [ProductImage]
                
                public struct ProductImage: Decodable {
                    public let url: String
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
    
    public var imageUrl: String {
        props.pageProps.product.imageList[0].url
    }
    
    public func toProduct(urlString: String) -> ClothesRegisterEntity {
        let product = props.pageProps.product
        
        return .init(
            name: product.name,
            brand: product.brand,
            link: urlString
        )
    }
}

public struct QueenitProduct: Clothesable {
    public let props: Props
    
    public struct Props: Decodable {
        public let pageProps: PageProps
        
        public struct PageProps: Decodable {
            public let dehydratedState: DehydratedState
            
            public struct DehydratedState: Decodable {
                public let queries: [Query]
                
                public struct Query: Decodable {
                    public let state: State
                    
                    public struct State: Decodable {
                        public let data: StateData
                        
                        public struct StateData: Decodable {
                            public let product: Product
                            
                            public struct Product: Decodable {
                                public let productId: String
                                public let imageUrl: String
                                public let name: String
                                public let originalPrice: Int
                                public let brand: String
                            }
                        }
                    }
                }
            }
        }
    }
    
    public var imageUrl: String {
        props.pageProps.dehydratedState.queries[0].state.data.product.imageUrl
    }
    
    public func toProduct(urlString: String) -> ClothesRegisterEntity {
        let product = props.pageProps.dehydratedState.queries[0].state.data.product
        
        return .init(
            name: product.name,
            brand: product.brand,
            link: urlString
        )
    }
}

public struct TwentyNineCMProduct: Clothesable {
    public let props: Props
    
    public struct Props: Decodable {
        public let pageProps: PageProps
        
        public struct PageProps: Decodable {
            public let dehydratedState: DehydratedState
            
            public struct DehydratedState: Decodable {
                public let queries: [Query]
                
                public struct Query: Decodable {
                    public let state: State
                    
                    public struct State: Decodable {
                        public let data: StateData
                        
                        public struct StateData: Decodable {
                            public let itemNo: Int
                            public let itemName: String
                            public let sellPrice: Int
                            public let itemImages: [ItemImage]
                            public let frontBrand: FrontBrand
                            
                            public struct ItemImage: Decodable {
                                public let imageUrl: String
                            }
                            
                            public struct FrontBrand: Decodable {
                                public let brandNameEng: String
                                public let brandNameKor: String
                            }
                        }
                    }
                }
            }
        }
    }
    
    public var imageUrl: String {
        "https://img.29cm.co.kr" + props.pageProps.dehydratedState.queries[0].state.data.itemImages[0].imageUrl
    }
    
    public func toProduct(urlString: String) -> ClothesRegisterEntity {
        let goods = props.pageProps.dehydratedState.queries[0].state.data
        
        return .init(
            name: goods.itemName,
            brand: goods.frontBrand.brandNameKor,
            link: urlString
        )
    }
}

public struct KreamProduct: Clothesable {
    public var name: String
    public var description: String
    public var image: [String]
    public var sku: String
    public var brand: Brand
    public var offers: Offers
    
    public struct Brand: Decodable {
        public var name: String
    }
    
    public struct Offers: Decodable {
        public var url: String
        public var price: Int
        public var priceCurrency: String
    }
    
    public var imageUrl: String {
        image[0]
    }
    
    public func toProduct(urlString: String) -> ClothesRegisterEntity {
        return .init(
            name: name,
            brand: brand.name,
            link: urlString
        )
    }
}
