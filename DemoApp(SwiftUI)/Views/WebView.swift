//
//  WebView.swift
//  DemoApp(SwiftUI)
//
//  Created by Aline Arely Ordonez Garcia on 07/06/21.
//

import SwiftUI

import SwiftUI
import WebKit

struct WebView : UIViewRepresentable {
    
    var url: String
    
    func makeUIView(context: Context) -> WKWebView  {
        guard let url = URL(string: self.url) else {
            return WKWebView()
        }
        let request = URLRequest(url: url)
        let webView = WKWebView()
        webView.load(request)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
    
}

#if DEBUG
struct WebView_Previews : PreviewProvider {
    static var previews: some View {
        WebView(url:"https://www.apple.com")
    }
}
#endif
