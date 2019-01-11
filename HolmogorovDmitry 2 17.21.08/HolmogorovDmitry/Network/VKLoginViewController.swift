//
//  LoginViewController.swift
//  HolmogorovDmitry
//
//  Created by Дмитрий on 04/11/2018.
//  Copyright © 2018 Dmitry. All rights reserved.
//

import UIKit
import  WebKit
import  Alamofire
import  FirebaseDatabase

class VKLoginViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self 
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "6753994"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "270350"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.85")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        webView.load(request)
        
    }

}

extension VKLoginViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
                
        guard let token = params["access_token"], let userId = Int(params["user_id"]!) else {
            decisionHandler(.cancel)
            return
        }
        
        //print(token, userId)
        Session.instance.token = token
        Session.instance.userId = userId
        
        
        let data = [Session.instance].map{$0.toAnyObject}
        let dbLink = Database.database().reference()
        dbLink.child("User").setValue(data)
//        print(data)
        
        self.performSegue(withIdentifier: "Show Base Controller", sender: nil )
 
        decisionHandler(.cancel)
    }
   
}
