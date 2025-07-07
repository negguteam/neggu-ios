//
//  BannerViewContainer.swift
//  BaseFeature
//
//  Created by 유지호 on 7/6/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import SwiftUI
import GoogleMobileAds

public struct BannerViewContainer: UIViewRepresentable {
    public typealias UIViewType = BannerView
    
    let adSize: AdSize
    
    public init(_ adSize: AdSize = AdSizeBanner) {
        self.adSize = adSize
    }
    
    public func makeUIView(context: Context) -> BannerView {
        let banner = BannerView(adSize: adSize)
        banner.adUnitID = "ca-app-pub-3940256099942544/2435281174"
        banner.load(Request())
        banner.delegate = context.coordinator
        return banner
    }
    
    public func updateUIView(_ uiView: BannerView, context: Context) {}
    
    public func makeCoordinator() -> BannerCoordinator {
        return BannerCoordinator(self)
    }
    
    public class BannerCoordinator: NSObject, BannerViewDelegate {
        
        let parent: BannerViewContainer
        
        init(_ parent: BannerViewContainer) {
            self.parent = parent
        }
        
        // MARK: - GADBannerViewDelegate methods
        
        public func bannerViewDidReceiveAd(_ bannerView: BannerView) {
            print("DID RECEIVE AD.")
        }
        
        public func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
            print("FAILED TO RECEIVE AD: \(error.localizedDescription)")
        }
    }
}
