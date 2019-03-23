//
//  WebOauthViewController.swift
//  Riku RH
//
//  Created by user on 01/04/2019.
//  Copyright © 2019 Esprit. All rights reserved.
//

import UIKit
import Alamofire

class WebOauthViewController: UIViewController,UIWebViewDelegate {
    
    var connected = false
    
    let webView:UIWebView = UIWebView(frame: CGRect(x:0, y:0, width: UIScreen.main.bounds.width, height:UIScreen.main.bounds.height))
    
    //linkedIn Api Key
    //let linkedInKey = "86c9o7xizay87a"
    let linkedInKey = "77h6ddl0nq1zr0"
    
    //State some uniq identifier for get login code
    let state = "linkedin\(Int(NSDate().timeIntervalSince1970))"
    
    // LinkedIn secret token
    //let linkedInSecret = "czKrfhEi8KTVl8Y4"
    let linkedInSecret = "ht8ZyikwNYxiA6Fe"
    
    //let authorizationEndPoint = "https:// www.linkedin.com/oauth/v2/authorization"
    //let accessTokenEndPoint = "https:// www.linkedin.com/uas/oauth2/accessToken"
    let authorizationEndPoint = "https://www.linkedin.com/uas/oauth2/authorization"
    let accessTokenEndPoint = "https://www.linkedin.com/uas/oauth2/accessToken"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(webView)
        
        webView.delegate = self
        startAuthorization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startAuthorization() {
        
        let responseType = "code"
        
        //your redirect url, DON'T forget add this to developer portal Oauth2 section
        let redirectURL = "http://www.google.com".addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        
        //let scope = "r_liteprofile,r_emailaddress"
        var authorizationURL = "\(authorizationEndPoint)?"
        authorizationURL += "response_type=\(responseType)&"
        authorizationURL += "client_id=\(linkedInKey)&"
        authorizationURL += "redirect_uri=\(redirectURL)&"
        authorizationURL += "state=\(state)"//"&"
        //authorizationURL += "scope=\(scope)"
        
        // logout already logined user or revoke tokens
        logout()
        
        // Create a URL request and load it in the web view.
        let request = URLRequest(url: URL(string: authorizationURL)!)
        print(authorizationURL)
        
        webView.loadRequest(request)
    }
    
    func logout(){
        let revokeUrl = "https://api.linkedin.com/uas/oauth/invalidateToken"
        let request = URLRequest(url: URL(string: revokeUrl)! as URL)
        webView.loadRequest(request)
    }
    
    
    func webView(_ webView: UIWebView,shouldStartLoadWith request: URLRequest,navigationType: UIWebView.NavigationType) -> Bool {
        
        let url = request.url!
        // catch oauth code and state, state should bee like your send state
        if url.host == "www.google.com" {
            if url.absoluteString.range(of:"code") != nil {
                let urlParts = url.absoluteString.components(separatedBy:"?")
                let code = urlParts[1].components(separatedBy:"=")[1]
                print("Code:", String(code.dropLast(6)))
                //Url code only for get auth token
                requestForAccessToken(authorizationCode:String(code.dropLast(6) ))
            }
        }
        return true
    }
    
    
    func  requestForAccessToken(authorizationCode:String) {
        
        let grantType = "authorization_code"
        
        //Enter redirect url here
        let redirectURL = "http://www.google.com".addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        print("redirectURL",redirectURL)
        
        // Set the POST parameters.
        var postParams = "grant_type=\(grantType)&"
        postParams += "code=\(authorizationCode)&"
        postParams += "redirect_uri=\(redirectURL)&"
        postParams += "client_id=\(linkedInKey)&"
        postParams += "client_secret=\(linkedInSecret)"
        
        
        let postData = postParams.data(using: String.Encoding.utf8)
        
        let request = NSMutableURLRequest(url: URL(string: accessTokenEndPoint)! as URL)
        
        request.httpMethod = "POST"
        request.httpBody = postData
        request.addValue("application/x-www-form-urlencoded;", forHTTPHeaderField: "Content-Type")
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            // Get the HTTP status code of the request.
            let statusCode = (response as! HTTPURLResponse).statusCode
            print("Status code", statusCode)
            if statusCode == 200 {
                // Convert the received JSON data into a dictionary.
                do {
                    let dataDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:Any]
                    print("dataDictionary\(dataDictionary)")
                    let accessToken = dataDictionary["access_token"] as! String
                   
                    // Now you get access token and you can use it for get profile info and other operations
                    UserDefaults.standard.set(accessToken, forKey: "LIAccessToken")
                    UserDefaults.standard.synchronize()
                    print("START sentData")
                    print(accessToken)
                    
                    DispatchQueue.main.async {

                        let url = "https://api.linkedin.com/v1/people/~:(id,firstName,lastName,headline,public-profile-url)"
                        let parameters: Parameters = ["oauth2_access_token": accessToken,"format":"json"]
                        
                        Alamofire.request(url, method: .get, parameters: parameters).responseJSON(completionHandler: {
                            (response) in
                            if response.result.isSuccess {
                                print("Login success")
                                self.connected = true
                                let resultDict = response.result.value as! Dictionary<String,String>
                                let id = String(resultDict["id"]!)
                                let firstName = String(resultDict["firstName"]!)
                                let lastName = String(resultDict["lastName"]!)
                                let headline = String(resultDict["headline"]!)
                                let publicProfileUrl = String(resultDict["publicProfileUrl"]!)
                                
                                UserDefaults.standard.set(id, forKey: "userId")
                                UserDefaults.standard.synchronize()
                                
                                print(id)
                                print(firstName)
                                print(lastName)
                                print(headline)
                                print(publicProfileUrl)
                                
                                // Insert User
                                let urlInsert = IP.init().url+"InsertUser.php"
                                let params : Parameters = ["id":id,"nom":lastName,"prenom":firstName,"fonction":headline,"url":publicProfileUrl]
                                Alamofire.request(urlInsert, method: .post, parameters: params).responseString(completionHandler: {
                                    (response) in
                                    switch response.result {
                                    case .success:
                                        print(response)
                                        
                                        break
                                    case .failure(let error):
                                        
                                        print(error)
                                    }
                                })
                                
                            }
                            else {
                                print("Login Failure")
                            }
                        })
                        self.dismiss(animated: false, completion: nil)
                    }
                } catch {
                    print("Could not convert JSON data into a dictionary.")
                }
            } else {
                print("cancel clicked")
                self.connected = false
                self.dismiss(animated: false, completion: nil)
                
            }
        }
        task.resume()
    }
    
}
