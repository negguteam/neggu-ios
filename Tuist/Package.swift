// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,] 
        productTypes: [:]
    )
#endif

let package = Package(
    name: "Neggu",
    dependencies: [
        .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "15.0.0")),
        
        .package(url: "https://github.com/google/GoogleSignIn-iOS", .upToNextMajor(from: "7.0.0")),
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", .upToNextMajor(from: "12.6.0")),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "11.0.0")),
        
        .package(url: "https://github.com/kakao/kakao-ios-sdk", .upToNextMajor(from: "2.22.5")),
        
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.6.0"),
//        .package(url: "https://github.com/gonzalezreal/swift-markdown-ui", from: "2.0.2")
    ]
)
