//
//  CustomWebView.swift
//  neggu
//
//  Created by 유지호 on 4/27/25.
//

import SwiftUI
import WebKit

struct CustomWebView: UIViewRepresentable {
    let url: String
        
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: url) else {
            return WKWebView()
        }
        
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: UIViewRepresentableContext<CustomWebView>) {
        guard let url = URL(string: url) else { return }
        
        webView.load(URLRequest(url: url))
    }
}
