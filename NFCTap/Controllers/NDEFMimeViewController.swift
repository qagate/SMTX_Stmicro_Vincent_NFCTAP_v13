//
//  NDEFMimeViewController.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 27/10/2017.
//  Copyright © 2017 STMicroelectronics. All rights reserved.
//

import UIKit
import WebKit

class NDEFMimeViewController: ST25UIViewController,WKNavigationDelegate {

    @IBOutlet weak var mimeTypeTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: WKWebView!
    
    @IBAction func refreshAction(_ sender: Any) {
        self.webView.reload()
    }
    
    @IBAction func stopAction(_ sender: Any) {
        
        self.webView.stopLoading()
    }
    
    var mimeId:String!
    var mimeContent:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       webView.navigationDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.textView.text = self.mimeContent
        self.mimeTypeTextField.text = self.mimeId
        
        guard let resourcePath = Bundle.main.path(forResource: self.mimeContent, ofType: nil) else {
            showAlert(string: NSLocalizedString("File not found",comment: ""))
            return
        }
        
        let resourceData = try! Data(contentsOf: URL(fileURLWithPath: resourcePath))
        webView.load(resourceData, mimeType: self.mimeId, characterEncodingName: "UTF-8", baseURL:  URL(fileURLWithPath: resourcePath))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setMime(mimeId : String, data: String){
        self.mimeId = mimeId
        self.mimeContent = data
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
        showAlert(string: error.localizedDescription)
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Start to load")
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finish to load")
        activityIndicator.stopAnimating()
    }
    
    private func showAlert(string: String) {
        let alert = UIAlertController(title: NSLocalizedString("Web View",comment: ""), message: string, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("CANCEL",comment: ""), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
