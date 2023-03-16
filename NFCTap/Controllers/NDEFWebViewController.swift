//
//  WebViewController.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 09/10/2017.
//  Copyright © 2017 STMicroelectronics. All rights reserved.
//

import UIKit
import WebKit
import SafariServices

class NDEFWebViewController: ST25UIViewController,WKNavigationDelegate,SFSafariViewControllerDelegate {

    @IBOutlet weak var webView: myWKWebView!
    @IBOutlet weak var smallView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var textViewString:String!
    var url:URL!
    var webViewTmp: WKWebView!
    
    @IBAction func openSafariAction(_ sender: Any) {
        let svc = SFSafariViewController(url: self.url!)
        svc.delegate = self
        self.present(svc, animated: true, completion: nil)
    }
  
    // WebView naviagtion actions
    @IBAction func refreshAction(_ sender: Any) {
         self.webView.reload()
    }
    
    @IBAction func stopAction(_ sender: Any) {
        self.webView.stopLoading()
    }
    @IBAction func fastForwardAction(_ sender: Any) {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    @IBAction func rewindAction(_ sender: Any) {
        if self.webView.canGoBack {
            self.webView.goBack()
        }
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // webview configuration
        /*
        let configuration = WKWebViewConfiguration()
        configuration.setURLSchemeHandler(nfctapSchemeHandler(), forURLScheme: "nfctap")
        
        webViewTmp = WKWebView(frame: smallView.frame, configuration: configuration)
        webViewTmp.scrollView.contentInsetAdjustmentBehavior = .never
        webViewTmp.center = smallView.center
        */
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        //smallView.addSubview(webView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.textView.text = self.textViewString
        
        webView.load(URLRequest(url: url))
        
        //let filePath = Bundle.main.path(forResource: "sample", ofType: "html")!
        //let url = URL(fileURLWithPath: filePath)
        //webView2.loadFileURL(url, allowingReadAccessTo: url)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setURL(url : URL, data: String){
        self.url = url
        self.textViewString = data
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
        showAlert(string: error.localizedDescription)
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Start to Load")
        activityIndicator.startAnimating()
    }
 
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finish to load")
        activityIndicator.stopAnimating()
     }
  
    private func showAlert(string: String) {
        let alert = UIAlertController(title: "Web View".localized, message: string, preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "CANCEL".localized, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

class myWKWebView: WKWebView {
    required convenience init?(coder: NSCoder) {
        let configuration = WKWebViewConfiguration()
        configuration.setURLSchemeHandler(nfctapSchemeHandler(), forURLScheme: "nfctap")
        
        self.init(frame: .zero, configuration: configuration)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
