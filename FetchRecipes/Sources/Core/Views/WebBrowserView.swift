//
//  WebBrowserView.swift
//  FetchRecipes
//
//  Created by Bogdan Chornobryvets on 11/10/24.
//

import Foundation
import SwiftUI
import SafariServices

struct WebBrowserView: UIViewControllerRepresentable {
    let url: URL
    var onDone: (() -> ())? = nil
    
    func makeUIViewController(
        context: UIViewControllerRepresentableContext<Self>
    ) -> UIViewController {
        
        let safariVC = SFSafariViewController(url: url)
        safariVC.delegate = context.coordinator
        safariVC.dismissButtonStyle = .close
        
        return safariVC
    }
    
    func updateUIViewController(
        _ uiViewController: UIViewController,
        context: UIViewControllerRepresentableContext<WebBrowserView>
    ) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(context: self)
    }
    
    final class Coordinator: NSObject, SFSafariViewControllerDelegate {
        let context: WebBrowserView
        
        init(context: WebBrowserView) {
            self.context = context
        }
        
        func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
            context.onDone?()
        }
    }
}

#Preview {
    WebBrowserView(
        url: URL(string: "https://google.com")!
    )
}
