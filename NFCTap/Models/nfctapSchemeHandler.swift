//
//  customSchemeHandler.swift
//  NFCTap
//
//  Created by STMICROELECTRONICS on 18/10/2017.
//  Copyright © 2017 STMicroelectronics. All rights reserved.
//

import UIKit
import WebKit



class nfctapSchemeHandler: NSObject, WKURLSchemeHandler {
  
    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        
        let imagePath = Bundle.main.path(forResource: "Icon-60@2x", ofType: "png")!
        let resourceData = try! Data(contentsOf: URL(fileURLWithPath: imagePath))
        let response = URLResponse(
            url: urlSchemeTask.request.url!,
            mimeType: "image/png",
            expectedContentLength: resourceData.count,
            textEncodingName: nil
        )
        urlSchemeTask.didReceive(response)
        urlSchemeTask.didReceive(resourceData)
        urlSchemeTask.didFinish()
    }
    
    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {
        urlSchemeTask.didFinish()
    }
    
}

