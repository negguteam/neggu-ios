//
//  Clothes.swift
//  neggu
//
//  Created by 유지호 on 9/6/24.
//

import Foundation

protocol Clothesable: Decodable {
    func toProduct(urlString: String) -> Clothes
}

struct Clothes: Equatable, Hashable, Identifiable {
    let id: String = UUID().uuidString
    var urlString: String
    var name: String
    var image: String
    var brand: String
    var price: Int
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
            urlString: urlString,
            name: goods.name,
            image: goods.image,
            brand: goods.market.name,
            price: goods.price
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
            urlString: urlString,
            name: name,
            image: image,
            brand: brand.name,
            price: Int(offers.price) ?? 0
        )
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
            urlString: urlString,
            name: name,
            image: image[0],
            brand: brand.name,
            price: offers[0].price
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
            urlString: urlString,
            name: goods.name,
            image: goods.imageUrl,
            brand: goods.brand,
            price: goods.originalPrice
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
            urlString: urlString,
            name: goods.itemName,
            image: "https://img.29cm.co.kr" + goods.itemImages[0].imageUrl,
            brand: goods.frontBrand.brandNameKor,
            price: goods.sellPrice
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
            urlString: urlString,
            name: name,
            image: image[0],
            brand: brand.name,
            price: offers.price
        )
    }
}
