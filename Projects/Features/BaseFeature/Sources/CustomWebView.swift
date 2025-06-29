//
//  CustomWebView.swift
//  neggu
//
//  Created by 유지호 on 4/27/25.
//

import SwiftUI
import WebKit

public struct CustomWebView: UIViewRepresentable {
    private let url: String
    
    public init(url: String) {
        self.url = url
    }
    
    public func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: url) else {
            return WKWebView()
        }
        
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }
    
    public func updateUIView(_ webView: WKWebView, context: UIViewRepresentableContext<CustomWebView>) {
        guard let url = URL(string: url) else { return }
        
        webView.load(URLRequest(url: url))
    }
}
