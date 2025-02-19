//
//  Clothes.swift
//  neggu
//
//  Created by 유지호 on 9/6/24.
//

import SwiftUI

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

struct ObjectId: Decodable, Hashable {
    let timestamp: Int
    let date: String
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
    
    func toLookBookItem() -> LookBookClothesItem {
        return .init(
            id: self.id,
            imageUrl: self.imageUrl,
            image: self.imageUrl.toUIImage()
        )
    }
    
    func toLookBookClothes() -> LookBookClothesEntity {
        return .init(
            id: self.id,
            imageUrl: imageUrl,
            scale: 1.0,
            angle: 0,
            xRatio: 0,
            yRatio: 0,
            zIndex: 0
        )
    }
}


private extension String {
    
    func toUIImage() -> UIImage? {
        guard let url = URL(string: self) else { return nil }
        
        let request = URLRequest(url: url)
        
        if let cachedResponse = URLCache.shared.cachedResponse(for: request),
           let cachedImage = UIImage(data: cachedResponse.data) {
            return cachedImage
        } else {
            Task.detached(priority: .high) {
                do {
                    let (data, response) = try await URLSession.shared.data(for: request)
                    let cachedData = CachedURLResponse(response: response, data: data)
                    URLCache.shared.storeCachedResponse(cachedData, for: request)
                    
                    return UIImage(data: data)
                } catch {
                    print(error.localizedDescription)
                    return nil
                }
            }
            
            return nil
        }
    }
    
}



protocol Clothesable: Decodable {
    func toProduct(urlString: String) -> Clothes
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
