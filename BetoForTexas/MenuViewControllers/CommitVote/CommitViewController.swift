//
//  CommitViewController.swift
//  BetoForTexas
//
//  Created by Benjamin on 8/20/18.
//  Copyright © 2018 BenjaminHill. All rights reserved.
//

import UIKit
import WebKit
class CommitViewController: UIViewController, WKNavigationDelegate{
    
//    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
//    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func webView(_ webView: WKWebView,didFinish navigation: WKNavigation!){
        activityIndicator.stopAnimating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        self.title = "Commit to Vote"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name:"Abolition", size:25)!]
        let url:URL = URL(string: "https://act.betofortexas.com/signup/commit")!
        
        let request:URLRequest = URLRequest(url: url);
        webView.load(request)
        //view.bringSubview(toFront: webView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
